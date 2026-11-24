#pragma once
#include "../defines.h"
#include "widgets.h"
#include <atomic>
#include <cstring>
#include <string>
#include "../test_case_ds.h"

// struct SavedTest {
//     std::string name;
//     std::string description;
//
//     CacheConfig config;
//     TestCase test;
// };

class WorkloadPanel {
public:
	void render();
	
	// checks if workload buttons toggled
	inline bool should_run_testbench() { bool c = testbench_running_; testbench_running_ = false; return c; }
	inline bool should_load_trace() { bool c = trace_running_; trace_running_ = false; return c; }

	// if so, load files(if testbench send to uart)
	const std::string_view get_testbench_path() const;
	const std::string_view get_trace_path() const;

	inline const i32 get_testbench_size() const {
		switch (dataset_) {
			case 0: return 64;
			case 1: return 128;
			case 2: return 256;
			case 3: return 512;
			case 4: return 1024;
			case 5: return 2048;
			default: break;
		}
		
		return -1;
	}

	// shows loading final trace file to program
	inline void set_testbench_completion(f32 c) { testbench_completion_.store(c); }
	inline void set_trace_completion(f32 c) { trace_completion_.store(c); }
	inline f32 get_testbench_completion() { return testbench_completion_.load(); }
	inline f32 get_trace_completion() { return trace_completion_.load(); }
	inline void set_test_case(TestCase* tc) { tc_ = tc; }


private:
	TestCase* tc_ = nullptr;

	int builtin_ = 0, dataset_ = 0;
	char custom_[2048] = "";
	char trace_[512]   = "";
	float height_ = 215.0f;

	std::atomic<f32> testbench_completion_{0.0f};
	std::atomic<f32> trace_completion_{0.0f};
	bool testbench_running_ = false;
	bool trace_running_ = false;

};
