#include "workload.h"
#include "widgets.h"

// test types ig
const char* const PATTERNS[] = {
	"Sequential Access",
};
const char* const PATTERN_DESCRIPTORS[] = {
	"Access memory sequentially from 0x0 to 0x1000.",
};
const char* const DATASET_SAMPLES[] = {
	"256 B", "512 B", "1 KiB", "4 KiB", "16 KiB", "64 KiB"
};

void WorkloadPanel::set_workload(const WorkloadConfig& w) {
	kind_ = w.kind; builtin_ = w.builtin_index; dataset_ = w.dataset_index;
	std::strncpy(custom_, w.custom_pattern.c_str(), sizeof(custom_) - 1); custom_[sizeof(custom_) - 1] = 0;
	std::strncpy(trace_,  w.trace_path.c_str(),     sizeof(trace_) - 1);  trace_[sizeof(trace_) - 1] = 0;
}

WorkloadConfig WorkloadPanel::get_workload() const {
	WorkloadConfig w;
	w.kind = kind_; w.builtin_index = builtin_; w.dataset_index = dataset_;
	w.custom_pattern = custom_; w.trace_path = trace_;
	return w;
}

void WorkloadPanel::render() {
	ImGui::BeginChild("Workload", ImVec2(0, height_), true);
	SectionHeader("Workload");

	if (ImGui::BeginTabBar("WorkloadTabs")) {
		// want to run builtin test
		if (ImGui::BeginTabItem("Built-in")) {
			kind_ = WorkloadKind::BuiltIn;
			ImGui::SetNextItemWidth(-FLT_MIN);
			ComboStr("##pattern", builtin_, PATTERNS);
			ImGui::PushTextWrapPos(0);
			ImGui::TextDisabled("%s", PATTERN_DESCRIPTORS[builtin_]);
			ImGui::PopTextWrapPos();
			ImGui::EndTabItem();
		}

		// custom access
		if (ImGui::BeginTabItem("Custom")) {
			kind_ = WorkloadKind::Custom;
			ImGui::InputTextMultiline("##custom", custom_, sizeof(custom_), ImVec2(-FLT_MIN, 70));
			ImGui::EndTabItem();
		}
		// TODO: ensure path correctness
		if (ImGui::BeginTabItem("Trace File")) {
			kind_ = WorkloadKind::TraceFile;
			ImGui::SetNextItemWidth(-FLT_MIN);
			ImGui::InputTextWithHint("##trace", "path/to/trace.txt", trace_, sizeof(trace_));
			ImGui::EndTabItem();
		}
		ImGui::EndTabBar();
	}

	LabeledRow("Dataset Size", 100);
	ImGui::SetNextItemWidth(ImGui::GetContentRegionAvail().x - 80);
	ComboStr("##dataset", dataset_, DATASET_SAMPLES);
	ImGui::SameLine();
	if (ImGui::Button("Generate", ImVec2(-FLT_MIN, 0))) generate_ = true;

	ImGui::EndChild();
}
