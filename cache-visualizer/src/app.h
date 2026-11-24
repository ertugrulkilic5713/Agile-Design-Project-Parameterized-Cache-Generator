#pragma once
#include "defines.h"
#include "gui/cache_config.h"
#include "gui/workload.h"
#include "gui/controls.h"
#include "gui/statistics.h"
#include "gui/workspace_tabs/cache_comparison.h"
#include "gui/workspace_tabs/cache_visual.h"
#include <chrono>
#include <thread>
#include <atomic>
#include <chrono>

class Application {
public:
	Application(void);
	~Application(void);
	void render(void);

	bool running;

	CacheConfigPanel cache_config_;
	WorkloadPanel workload_;
	ControlsPanel controls_;
	StatisticsPanel statistics_;

	CacheVisual cache_visual_;
	CacheComparison comparison_;
private:
	void dark_theme();
	void update();
	void update_control_panel();
	void update_config_panel();
	void update_workload_panel();
	void update_comparison_panel();
	void update_cache_visualizer();

	// for hardware communication
	std::thread testbench_thread_;
	std::atomic<bool> testbench_running_{false};

	// for visualizing
	std::atomic<bool> new_test_case_{false}; // need to know for comparison_ / running cache visualizer
	std::mutex test_cases_mutex_;
	std::vector<TestCase> all_test_cases_;
	usize idx_test_case_;
	usize current_running_transaction_;

	// cache visualizer tab
	bool running_test_case_;
	f32 speed_;
	std::chrono::steady_clock::time_point last_test_time_ = // goddam these are long, wth
		std::chrono::steady_clock::now();

	void load_test_case_from_trace(const std::string& path);
	void run_test_case_from_testbench(const std::string& path, const CacheConfig& config);


};
