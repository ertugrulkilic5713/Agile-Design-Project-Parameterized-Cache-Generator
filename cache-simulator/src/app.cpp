#include "app.h"
#include "imgui.h"
#include "test/test_cases.h"

Application::Application(void) : running(true), running_test_cases_(false) {
	Test::test_cache_impl(cache_);
	cache_visual_.set_cache(&cache_);
}

void Application::update_control_panel() {
	ControlEvents e = controls_.consume_events();
	if (e.run) {
		running_test_cases_ = true;
		test_case_ = 0;
	}
	if (e.stop) {
		running_test_cases_ = false;
		test_case_ = 0;
	}
	if (e.pause) {
		running_test_cases_ = false;
	}
}

// updates based on gui widgets
void Application::update() {
	update_control_panel();
}

void Application::render() {
	// if (!theme_set_) {
	//		dark_theme(); // save your eyes
	// }
	update();
	const auto interval = std::chrono::duration<f32>(
		1.0 / std::max(0.1f, controls_.get_speed())
	);

    auto now = std::chrono::steady_clock::now();
    if (test_case_ < Test::test_case_count() &&
        now - last_test_time_ >= interval && 
		running_test_cases_
	) {

		Test::run_test_case(
            test_case_++,
            cache_,
            current_request_,
            current_result_,
            &test_description_
        );

		statistics_.update_stats(current_result_, timing_);

		// highlight the matching way, or allocated way on a miss.
		int way = current_result_.hit_
			? current_result_.way_
			: current_result_.victim_way_;

		cache_visual_.set_line(current_result_.set_, way);
        cache_visual_.set_result(current_result_);

        last_test_time_ = now;
		printf("updated\n");
    }


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
		if (ImGui::BeginTabItem("Performance")) { 
			ImGui::TextDisabled("Performance - not implemented yet");
			ImGui::EndTabItem();
		}

		// can compare between different configs with saves test samples
		if (ImGui::BeginTabItem("Comparison")) { 
			ImGui::TextDisabled("Comparison - not implemented yet");
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

