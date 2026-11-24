#include "workload.h"
#include "widgets.h"

// test types ig
const char* const PATTERNS[] = {
	"Sequential",
	"Strided",
	"Random",
	"Hot Set",
	"Conflict",
	"Mixed Read/Write",
};
const char* const PATTERN_DESCRIPTORS[] = {
	"Contiguous 4-byte access",
	"64-byte spacing",
	"Seeded random addresses",
	"80% temporal locality",
	"Address seperated by 4KiB",
	"Recurring working set, 20% writes"
};
const char* const DATASET_SAMPLES[] = {
	"64 Req", "128 Req", "256 Req", "512 Req", "1024 Req", "2048 Req"
};

// Rows follow PATTERNS[], columns follow DATASET_SAMPLES[]
constexpr size_t NUM_PATTERNS = 6;
constexpr size_t NUM_DATASETS = 6;
constexpr const char* const BUILTIN_PATHS[NUM_PATTERNS][NUM_DATASETS] = {
    { "sequential_64.txt", "sequential_128.txt", "sequential_256.txt",
      "sequential_512.txt", "sequential_1024.txt", "sequential_2048.txt" },
    { "strided_64.txt", "strided_128.txt", "strided_256.txt",
      "strided_512.txt", "strided_1024.txt", "strided_2048.txt" },
    { "random_64.txt", "random_128.txt", "random_256.txt",
      "random_512.txt", "random_1024.txt", "random_2048.txt" },
    { "hot_set_64.txt", "hot_set_128.txt", "hot_set_256.txt",
      "hot_set_512.txt", "hot_set_1024.txt", "hot_set_2048.txt" },
    { "conflict_64.txt", "conflict_128.txt", "conflict_256.txt",
      "conflict_512.txt", "conflict_1024.txt", "conflict_2048.txt" },
    { "mixed_rw_64.txt", "mixed_rw_128.txt", "mixed_rw_256.txt",
      "mixed_rw_512.txt", "mixed_rw_1024.txt", "mixed_rw_2048.txt" },
};


const std::string_view WorkloadPanel::get_testbench_path() const {
	if (builtin_ < 0 || dataset_ < 0 ||
		static_cast<size_t>(builtin_) >= NUM_PATTERNS ||
		static_cast<size_t>(dataset_) >= NUM_DATASETS)
        return {};
    return BUILTIN_PATHS[builtin_][dataset_];
}

const std::string_view WorkloadPanel::get_trace_path() const {
	return std::string_view(trace_, strnlen(trace_, sizeof(trace_)));
}

void WorkloadPanel::render() {
	ImGui::BeginChild("Workload", ImVec2(0, height_), true);
	SectionHeader("Workload");

	if (ImGui::BeginTabBar("WorkloadTabs")) {
		// want to run builtin test
		if (ImGui::BeginTabItem("Built-in")) {
			ImGui::SetNextItemWidth(-FLT_MIN);
			ComboStr("##pattern", builtin_, PATTERNS);
			ImGui::PushTextWrapPos(0);
			ImGui::TextDisabled("%s", PATTERN_DESCRIPTORS[builtin_]);
			ImGui::PopTextWrapPos();

			// prepare to run dataset
			LabeledRow("Dataset Size", 100);
			ImGui::SetNextItemWidth(ImGui::GetContentRegionAvail().x / 2);
			ComboStr("##dataset", dataset_, DATASET_SAMPLES);
			ImGui::SameLine();
			if (ProgressButton("Run", testbench_completion_, ImVec2(-FLT_MIN, 0))) {
				testbench_completion_ = 0.001f;
				testbench_running_ = true;
			}

			ImGui::EndTabItem();
		}

		// loaded work
		static char test_name_[128] = "Untitled Test";
		static char test_description_[512] = "";
		if (ImGui::BeginTabItem("Current Test")) {
			if (!tc_) {
				ImGui::TextDisabled("No testcase loaded.");
			} else {
				ImGui::InputText(
					"Name",
					test_name_,
					sizeof(test_name_)
				);

				ImGui::InputTextMultiline(
					"Description",
					test_description_,
					sizeof(test_description_),
					ImVec2(-FLT_MIN, 70)
				);

				ImGui::Spacing();

				ImGui::Separator();

				ImGui::Text("Requests: %zu", tc_->req.size());
				ImGui::Text("Responses: %zu", tc_->resp.size());

				ImGui::Spacing();

				if (ImGui::Button("Save Test", ImVec2(-FLT_MIN, 0))) {
					// SavedTest saved{
					// 	.name = test_name_,
					// 	.description = test_description_,
					// 	.config = current_config_,
					// 	.test = current_test_
					// };
					//
					// saved_tests_.push_back(std::move(saved));
				}
			}


			ImGui::EndTabItem();
		}

		// TODO: ensure path correctness
		if (ImGui::BeginTabItem("Trace File")) {
			// ImGui::SetNextItemWidth(-FLT_MIN);
			ImGui::InputTextWithHint("##trace", "path/to/trace.txt", trace_, sizeof(trace_));

			ImGui::SameLine();
			if (ProgressButton("Load", trace_completion_, ImVec2(-FLT_MIN, 0))) {
				trace_completion_ = 0.001f;
				trace_running_ = true;
			}

			ImGui::EndTabItem();
		}
		ImGui::EndTabBar();
	}



	ImGui::EndChild();
}
