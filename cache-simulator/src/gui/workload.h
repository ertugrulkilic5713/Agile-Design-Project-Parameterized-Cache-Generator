#pragma once
#include "../defines.h"
#include <cstring>
#include <string>

enum class WorkloadKind { BuiltIn, Custom, TraceFile };
struct WorkloadConfig {
	WorkloadKind kind = WorkloadKind::BuiltIn;
	int builtin_index = 0; // index into pattern list
	int dataset_index = 2; // index into dataset-size list
	std::string custom_pattern;
	std::string trace_path;
};

class WorkloadPanel {
public:
	void render();

	void set_workload(const WorkloadConfig& w);
	WorkloadConfig get_workload() const;

	// true once after "Generate" was pressed; cleared on read
	bool consume_generate() { bool g = generate_; generate_ = false; return g; }

private:
	WorkloadKind kind_ = WorkloadKind::BuiltIn;
	int builtin_ = 0, dataset_ = 2;
	char custom_[2048] = "";
	char trace_[512]   = "";
	bool generate_ = false;
	float height_ = 215.0f;
};
