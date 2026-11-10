#pragma once
#include "defines.h"
#include "gui/cache_config.h"
#include "gui/workload.h"
#include "gui/controls.h"
#include "gui/statistics.h"
#include "gui/workspace_tabs/cache_visual.h"
#include <chrono>


class Application {
public:
	Application(void);
	void render(void);

	bool running;

	CacheConfigPanel cache_config_;
	WorkloadPanel workload_;
	ControlsPanel controls_;
	StatisticsPanel statistics_;
	CacheVisual cache_visual_;
private:
	void dark_theme();
	void update();
	void update_control_panel();

	bool theme_set_ = false;
	CacheSnapshot cache_; // just visual data, references hardware info

	// for cache testing for now
	bool running_test_cases_;
	CacheRequest current_request_;
	CacheLookupResult current_result_;
	CacheTiming timing_;
	size_t test_case_ = 0;
	std::string test_description_ = "";
	std::chrono::steady_clock::time_point last_test_time_;
};
