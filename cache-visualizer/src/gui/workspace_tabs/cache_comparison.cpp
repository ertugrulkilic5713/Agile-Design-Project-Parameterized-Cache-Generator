#include "cache_comparison.h"

#include <imgui.h>
#include "../../implot/implot.h"
#include <algorithm>
#include <cstdio>
#include <limits>

void CacheComparison::clear() {
    runs_.clear();
}

void CacheComparison::render() {
	render_toolbar();

	ImGui::Separator();
	ImGui::BeginChild("ComparisonDatasets", ImVec2(0,0), false);

	if (runs_.empty()) {
        ImGui::Spacing();
        ImGui::TextDisabled("No datasets available.");
        ImGui::TextDisabled("Run a cache benchmark to populate comparisons.");
	}

	usize idx = 0;
	for (const auto& run : runs_) {
		render_run(run, idx);
		idx++;
	}

	ImGui::EndChild();
}

void CacheComparison::render_toolbar() {
    ImGui::Text("Cache Comparison");

    ImGui::SameLine();

    ImGui::TextDisabled(
        "%zu datasets",
        runs_.size()
    );

    ImGui::SameLine();

    ImGui::SetCursorPosX(
        ImGui::GetWindowWidth() - 80.0f
    );

    if (ImGui::SmallButton("Clear")) {
        clear();
    }
}

void CacheComparison::render_hit_rate_graph(
    const CacheComparisonConfigRun& run
) {
    if (!ImPlot::BeginPlot(
        "Hit Rate Over Requests",
        ImVec2(-1, 240)
    ))
        return;

    ImPlot::SetupAxes("Request", "Hit Rate (%)");

    ImPlot::SetupAxisLimits(
        ImAxis_Y1, 0.0, 150.0, ImGuiCond_Always
    );

    for (usize d = 0; d < run.datasets.size(); d++) {
        const auto& tc = run.datasets[d];

        if (tc.resp.empty())
            continue;

        std::vector<double> x;
        std::vector<double> y;

        u64 hits = 0;

        for (usize i = 0; i < tc.resp.size(); i++) {
            if (tc.resp[i].status & Data::HIT)
                hits++;

            x.push_back(static_cast<double>(i + 1));

            y.push_back(
                100.0 * static_cast<double>(hits) / (i + 1)
            );
        }

        std::string label = "Testcase " + std::to_string(d + 1);

        ImPlot::PlotLine(
            label.c_str(),
            x.data(),
            y.data(),
            static_cast<int>(x.size())
        );
    }

    ImPlot::EndPlot();
}

void CacheComparison::render_latency_graph(
    const CacheComparisonConfigRun& run
) {
    if (!ImPlot::BeginPlot(
        "Latency Over Time",
        ImVec2(-1, 240)
    ))
        return;

    ImPlot::SetupAxes(
        "Clock Cycles (tick)",
        "Latency (tick)"
    );

    for (usize d = 0; d < run.datasets.size(); d++) {
        const auto& tc = run.datasets[d];

        if (tc.resp.empty())
            continue;

        std::vector<double> x;
        std::vector<double> y;

        const u64 start = tc.resp.front().timestamp;

        for (const auto& response : tc.resp) {
            x.push_back(
                static_cast<double>(response.timestamp - start)
            );

            y.push_back(
                static_cast<double>(response.latency)
            );
        }

        std::string label = "Testcase " + std::to_string(d + 1);

        ImPlot::PlotLine(
            label.c_str(),
            x.data(),
            y.data(),
            static_cast<int>(x.size())
        );
    }

    ImPlot::EndPlot();
}

void CacheComparison::render_run(
	const CacheComparisonConfigRun& run, 
	usize index
) {
	ImGui::PushID(run.id.c_str());

    // Configuration header.
    ImGui::PushStyleVar(
        ImGuiStyleVar_FramePadding,
        ImVec2(10.0f, 12.0f)
    );

    ImGui::PushStyleVar(
        ImGuiStyleVar_ItemSpacing,
        ImVec2(8.0f, 4.0f)
    );

    bool expanded = ImGui::CollapsingHeader(
        "##Configuration",
        ImGuiTreeNodeFlags_AllowOverlap
    );

    // Overlay the configuration name and metrics
    // on the same header row.
    ImGui::SameLine();

    ImGui::SetCursorPosX(
        ImGui::GetCursorPosX() + 2.0f
    );

    ImGui::Text("%s", run.id.c_str());

    ImGui::SameLine();

    float width = ImGui::GetContentRegionAvail().x;

    // Metric columns.
    float metric_width = width / 3.0f;

    ImGui::SetCursorPosX(
        ImGui::GetWindowWidth() - width
    );

    ImGui::SameLine();
    ImGui::TextDisabled("Hit Rate");
    ImGui::SameLine();
    ImGui::Text("%.2f%%", run.total_hit_rate());

    ImGui::SameLine();
    ImGui::TextDisabled("Avg Latency");
    ImGui::SameLine();
    ImGui::Text("%.2f ns", run.avg_latency_ns());

    ImGui::SameLine();
    ImGui::TextDisabled("Total Time");
    ImGui::SameLine();
    ImGui::Text("%.3f ms", run.total_time_ns() / 1e6);


	// for loading config to configuration panel 
	// for running other data sets with same config
	ImGui::SameLine();
	ImGui::SetCursorPosX(
		ImGui::GetWindowWidth()
		- ImGui::GetStyle().WindowPadding.x
		- ImGui::CalcTextSize("Load Config").x
		- ImGui::GetStyle().FramePadding.x * 2.0f
	);

	if (ImGui::SmallButton(
		"Load Config"
	)) {
		selected_config_ = index;
		load_config_ = true;
	}

    ImGui::PopStyleVar(2);

    // Expanded section.
    if (expanded) {
		ImGui::Indent(16.0f);

		ImGui::Spacing();

		render_hit_rate_graph(run);
		render_latency_graph(run);

		ImGui::Spacing();

		ImGui::Unindent(16.0f);
    }

    ImGui::PopID();
}

CacheComparisonConfigRun* CacheComparison::find_config(
    const CacheConfig& config
) {
    for (auto& run : runs_) {
        if (run.config == config)
            return &run;
    }

    return nullptr;
}

CacheComparisonConfigRun& CacheComparison::add_config(
    const CacheConfig& config
) {
    // Reuse existing configuration.
    if (auto* existing = find_config(config))
        return *existing;

	static u32 id = 0;
	id++;

    runs_.push_back({
        .name = "Configuration " + std::to_string(runs_.size() + 1),
		.id = "Config #" + std::to_string(id),
        .config = config
    });

    return runs_.back();
}

bool CacheComparison::add_data_set(
    const CacheConfig& config,
    TestCase dataset
) {
    auto& run = add_config(config);

    run.datasets.push_back(std::move(dataset));

    return true;
}
