#include "app.h"
#include "imgui.h"
#include "data/transact.h"
#include "data/net_socket/hardware_client.h"
#include <algorithm>
#include <csignal>
#include <mutex>
#include <unistd.h>

void calculate_stats(TestCase& tc);

Application::Application(void) : 
	running(true), 
	running_test_case_(false),
	idx_test_case_(0),
	current_running_transaction_(0)
{
	// default intiialization
	cache_visual_.configure(cache_config_.get_config());
}

Application::~Application(void) {
	if (testbench_thread_.joinable()) {
		testbench_thread_.join();
	}
}

void Application::update_control_panel() {
	ControlEvents e = controls_.consume_events();
	if (e.run) {
		running_test_case_ = true;
		current_running_transaction_ = 0;
	}
	if (e.stop) {
		running_test_case_ = false;
		current_running_transaction_ = 0;
		cache_visual_.reset();
	}
	if (e.pause) {
		running_test_case_ = false;
	}
	speed_ = controls_.get_speed();
}

void Application::update_config_panel() {
	if (cache_config_.has_changed()) {
		cache_visual_.configure(
			cache_config_.get_config()
		);

		// reset other things
		controls_.reset();
	}
}

void Application::update_comparison_panel() {
	auto result = comparison_.get_config();
	if (result.has_value()) {
		cache_config_.set_config(*result);
	}

	if (new_test_case_.load()) {
		TestCase& tc = all_test_cases_.back();
		calculate_stats(tc);
		comparison_.add_data_set(cache_config_.get_config(), tc);
		workload_.set_test_case(&tc);

		new_test_case_.store(false);
	}
}

void Application::update_workload_panel() {
	if (workload_.should_load_trace()) {
		std::string_view sv = workload_.get_trace_path();

	}
	if (workload_.should_run_testbench() && !testbench_running_.load()) {
		if (testbench_thread_.joinable()) testbench_thread_.join();

		CacheConfig config = cache_config_.get_config();
		std::string_view sv = workload_.get_testbench_path();
		std::string path = "data_sets/testbench_requests/" + std::string(sv);
		workload_.set_testbench_completion(0.0f);
		testbench_running_.store(true);
		idx_test_case_ = all_test_cases_.size();
		testbench_thread_ = std::thread([this, path, config]() {
			try {
				run_test_case_from_testbench(path, config);
			} catch(const std::exception& e) {
                fprintf(stderr, "Testbench error: %s\n", e.what());
			}

            testbench_running_.store(false);
		});
	}
}

// updates based on gui widgets
void Application::update() {
	update_control_panel();
	update_config_panel();
	update_workload_panel();
	update_comparison_panel();
	update_cache_visualizer();
}

// called for workload trace file path
void Application::load_test_case_from_trace(const std::string& path) {
	TestCase tc;
}

// called for workload builtin testbenches
void Application::run_test_case_from_testbench(
    const std::string& path,
    const CacheConfig& config
) {
    TestCase tc;

    // Parse workload before starting hardware.
    tc.req = Data::parse_workload_file(path);

    if (tc.req.empty()) {
        fprintf(stderr, "Testbench contains no requests\n");
        return;
    }

    pid_t simulator_pid = -1;
    i32 socket = -1;

    try {
        // Start Chisel simulator.
        simulator_pid = NetSocket::start_simulator(config);

        printf("Waiting for simulator...\n");

        // Wait for TCP server.
        socket = NetSocket::wait_for_server(
            "127.0.0.1",
            9000,
            60
        );

        if (socket < 0) {
            throw std::runtime_error(
                "Simulator failed to start"
            );
        }

        printf("Simulator connected. Running workload...\n");

        // Execute workload in batches.
        constexpr usize BATCH_SIZE = 8;

        tc.resp.reserve(tc.req.size());

        for (usize i = 0; i < tc.req.size(); i += BATCH_SIZE) {
            usize count = std::min(
                BATCH_SIZE,
                tc.req.size() - i
            );

            std::vector<Data::Request> batch(
                tc.req.begin() + i,
                tc.req.begin() + i + count
            );

			// collects and sends to connected server
            auto responses =
                Data::socket_transact_batch(socket, batch);

            tc.resp.insert(
                tc.resp.end(),
                responses.begin(),
                responses.end()
            );

			// visaul thing
            workload_.set_testbench_completion(
                static_cast<f32>(tc.resp.size()) /
                static_cast<f32>(tc.req.size())
            );
        }

        NetSocket::close_socket(socket);
        socket = -1;

        // Stop simulator.
        kill(simulator_pid, SIGTERM);
        waitpid(simulator_pid, nullptr, 0);

        simulator_pid = -1;

        // Publish completed testcase.
        {
            std::lock_guard<std::mutex> lock(test_cases_mutex_);

            all_test_cases_.push_back(std::move(tc));
        }

        workload_.set_testbench_completion(1.0f);

        printf("Testbench completed successfully.\n");
		new_test_case_.store(true);
    } catch (const std::exception& e) {
        fprintf(stderr, "Testbench error: %s\n", e.what());

        if (socket >= 0) {
            NetSocket::close_socket(socket);
        }

        if (simulator_pid > 0) {
            kill(simulator_pid, SIGTERM);
            waitpid(simulator_pid, nullptr, 0);
        }
    }
}

void Application::update_cache_visualizer() {
    if (!running_test_case_)
        return;

    if (idx_test_case_ >= all_test_cases_.size()) {
        running_test_case_ = false;
        return;
    }

    auto& tc = all_test_cases_[idx_test_case_];

    if (current_running_transaction_ >= tc.req.size()) {
        running_test_case_ = false;
        return;
    }

    const auto interval = std::chrono::duration<f32>(
        1.0f / std::max(0.1f, speed_)
    );

    const auto now = std::chrono::steady_clock::now();

    if (now - last_test_time_ < interval)
        return;

    const usize i = current_running_transaction_;

	// updating visauls
    cache_visual_.apply(
        tc.req[i],
        tc.resp[i]
    );

	statistics_.apply(tc.resp[i]);

	// finished

    current_running_transaction_++;

    last_test_time_ = now;

    if (current_running_transaction_ >= tc.req.size()) {
        running_test_case_ = false;
    }
}

void Application::render() {
	update();
	
	// makes imgui fullscreen
	const ImGuiViewport* viewport = ImGui::GetMainViewport();
    ImGui::SetNextWindowPos(viewport->WorkPos);
    ImGui::SetNextWindowSize(viewport->WorkSize);

	ImGui::Begin("Application", nullptr, 
		ImGuiWindowFlags_NoDecoration |
        ImGuiWindowFlags_NoMove |
        ImGuiWindowFlags_NoSavedSettings |
        ImGuiWindowFlags_NoBringToFrontOnFocus
	);

    ImVec2 window_size = ImGui::GetIO().DisplaySize;

	// dims for each panel
	f32 information_panel_width = window_size.x * 0.3f;
	f32 cache_configuration_height = window_size.y * 0.4f;
	f32 workload_height = window_size.y * 0.25f;
	f32 controls_height = window_size.y * 0.1f;

	// Config Panel
	ImGui::BeginChild("Information", ImVec2(information_panel_width, 0), true);
		ImGui::BeginChild(
			"CacheConfiguration", 
			ImVec2(0, cache_configuration_height), 
			true
		);
		cache_config_.render();
		ImGui::EndChild();

		ImGui::BeginChild("Workload", ImVec2(0, workload_height), true);
		workload_.render();
		ImGui::EndChild();

		ImGui::BeginChild("Controls", ImVec2(0, controls_height), true);
		controls_.render();
		ImGui::EndChild();

		ImGui::BeginChild("Statistics", ImVec2(0, 0), true); // takes up residual
		statistics_.render();
		ImGui::EndChild();
	ImGui::EndChild();

	ImGui::SameLine();

	// Info Panel
	ImGui::BeginChild("Visualizer", ImVec2(0, 0), true);
	if (ImGui::BeginTabBar("WorkspaceTabs")) {
		if (ImGui::BeginTabItem("Cache Table")) { 
			cache_visual_.render();
			ImGui::EndTabItem();
		}

		// performance information if needed
		// more indepth look or something
		// if (ImGui::BeginTabItem("Performance")) { 
		// 	ImGui::TextDisabled("Performance - not implemented yet");
		// 	ImGui::EndTabItem();
		// }

		// can compare between different configs with saves test samples
		if (ImGui::BeginTabItem("Comparison")) { 
			comparison_.render();
			ImGui::EndTabItem();
		}
		ImGui::EndTabBar();
	}
	ImGui::EndChild();

	ImGui::End();
}


void Application::dark_theme() {
	// todo to make it look better
	ImGuiStyle& style = ImGui::GetStyle();
}

void calculate_stats(TestCase& tc) {
    // Reset all aggregate metrics
    tc.hits = 0;
    tc.misses = 0;
    tc.reads = 0;
    tc.writes = 0;
    tc.read_hits = 0;
    tc.write_hits = 0;
    tc.evictions = 0;
    tc.writebacks = 0;
    tc.write_throughs = 0;

    tc.total_latency_ns = 0;
    tc.min_latency_ns = UINT64_MAX;
    tc.max_latency_ns = 0;

    // Calculate metrics from responses
    for (const auto& resp : tc.resp) {
        const bool hit = resp.status & Data::HIT;
        const bool miss = resp.status & Data::MISS;
        const bool is_write = resp.status & Data::IS_WRITE;

        // Hits and misses
        if (hit) {
            tc.hits++;

            if (is_write)
                tc.write_hits++;
            else
                tc.read_hits++;
        }

        if (miss)
            tc.misses++;

        // Read/write accesses
        if (is_write)
            tc.writes++;
        else
            tc.reads++;

        // Cache events
        if (resp.status & Data::EVICT)
            tc.evictions++;

        if (resp.status & Data::WRITE_BACK)
            tc.writebacks++;

        if (resp.status & Data::WRITE_THROUGH)
            tc.write_throughs++;

        // Latency statistics
        const u64 latency = resp.latency;

        tc.total_latency_ns += latency;
        tc.min_latency_ns = std::min(tc.min_latency_ns, latency);
        tc.max_latency_ns = std::max(tc.max_latency_ns, latency);
    }

    // Handle empty testcase
    if (tc.resp.empty()) {
        tc.min_latency_ns = 0;
    }
}
