#include "statistics.h"
#include "widgets.h"

void StatisticsPanel::apply(const Data::Response& response) {
	const auto status = response.status;

	if (status & Data::HIT)
		stats_.hits++;

	if (status & Data::MISS)
		stats_.misses++;

	if (status & Data::EVICT)
		stats_.evictions++;

	if (status & Data::WRITE_BACK)
		stats_.writebacks++;

	stats_.total_cycles++;
}

void StatisticsPanel::render() {
	SectionHeader("Statistics");

	if (ImGui::BeginTable("stats", 2, ImGuiTableFlags_SizingStretchProp)) {
		ImGui::TableSetupColumn("k", ImGuiTableColumnFlags_WidthStretch, 1.0f);
		ImGui::TableSetupColumn("v", ImGuiTableColumnFlags_WidthStretch, 1.4f);

		// helper
		auto row = [](const char* k, const char* fmt, auto v) {
			ImGui::TableNextRow();
			ImGui::TableSetColumnIndex(0); ImGui::TextUnformatted(k);
			ImGui::TableSetColumnIndex(1); ImGui::Text(fmt, v);
		};

		// load each row
		char hit_rate[8];
		snprintf(hit_rate, sizeof(hit_rate), "%.0f%%", stats_.hit_rate() * 100.0f);
		
		row("Hit Rate", "%s", hit_rate);
		row("Total Hits", "%llu", (unsigned long long)stats_.hits);
		row("Total Misses", "%llu", (unsigned long long)stats_.misses);
		row("Evictions", "%llu", (unsigned long long)stats_.evictions);
		row("Write-Backs", "%llu", (unsigned long long)stats_.writebacks);

		ImGui::TableNextRow();
		ImGui::TableSetColumnIndex(0); ImGui::Separator();
		ImGui::TableSetColumnIndex(1); ImGui::Separator();

		// final values
		row("Total Cycles", "%llu", (unsigned long long)stats_.total_cycles);
		row("Avg. Latency", "%.2f cycles", stats_.avg_latency());
		ImGui::EndTable();
	}
}
