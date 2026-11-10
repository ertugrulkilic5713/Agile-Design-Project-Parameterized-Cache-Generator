#include "cache_visual.h"
#include "../widgets.h"
#include <string>

void CacheVisual::render() {
    if (!cache_ || cache_->sets_ == 0 || cache_->ways_ == 0) {
        ImGui::TextDisabled("No cache data");
        return;
    }

    const int column_count = 1 + cache_->ways_ * 4;

    constexpr ImGuiTableFlags flags =
        ImGuiTableFlags_Borders |
        ImGuiTableFlags_RowBg |
        ImGuiTableFlags_Resizable |
        ImGuiTableFlags_SizingFixedFit |
        ImGuiTableFlags_ScrollX |
        ImGuiTableFlags_ScrollY |
        ImGuiTableFlags_Hideable;

    if (!ImGui::BeginTable(
            "CacheTable",
            column_count,
            flags,
            ImVec2(0, 0))) {
        return;
    }

    // Index column.
    ImGui::TableSetupColumn(
        "Index",
        ImGuiTableColumnFlags_WidthFixed,
        55.0f
    );

    // Four columns per way.
    for (int way = 0; way < cache_->ways_; ++way) {
        char name[32];

        snprintf(name, sizeof(name), "W%d Valid", way);
        ImGui::TableSetupColumn(name, ImGuiTableColumnFlags_WidthFixed, 45.0f);

        snprintf(name, sizeof(name), "W%d Dirty", way);
        ImGui::TableSetupColumn(name, ImGuiTableColumnFlags_WidthFixed, 45.0f);

        snprintf(name, sizeof(name), "W%d Tag", way);
        ImGui::TableSetupColumn(name, ImGuiTableColumnFlags_WidthFixed, 90.0f);

        snprintf(name, sizeof(name), "W%d Word", way);
        ImGui::TableSetupColumn(name, ImGuiTableColumnFlags_WidthFixed, 110.0f);
    }

    ImGui::TableSetupScrollFreeze(1, 1);
    ImGui::TableHeadersRow();

    // determines lookup highlighting
    const bool valid_selection =
        search_index_ >= 0 &&
        search_index_ < cache_->sets_;

    const bool hit = current_result_.hit_;

    // shows words
    for (int index = 0; index < cache_->sets_; ++index) {
        const bool selected_set = valid_selection &&
                                  index == search_index_;

        ImGui::TableNextRow();

        // index
        ImGui::TableSetColumnIndex(0);

        if (selected_set) {
            ImGui::TableSetBgColor(
                ImGuiTableBgTarget_CellBg,
                IM_COL32(40, 100, 180, 130)
            );
        }

        ImGui::Text("%d", index);

        // ways
        for (int way = 0; way < cache_->ways_; ++way) {
            const auto& line = cache_->at(index, way);

            const int base = 1 + way * 4;

            const bool selected_way = way == search_way_;
            const bool selected_cell = selected_set && selected_way;

            ImU32 cell_color = 0;

            if (selected_set) {
                cell_color = IM_COL32(40, 100, 180, 100);
            }

            if (selected_cell) {
                cell_color = hit
                    ? IM_COL32(40, 160, 80, 180)   // hit
                    : IM_COL32(210, 120, 30, 180); // miss
            }

            // valid
            ImGui::TableSetColumnIndex(base);

            if (selected_set)
                ImGui::TableSetBgColor(
                    ImGuiTableBgTarget_CellBg, cell_color);

            ImGui::Text("%d", line.valid_);

            // dirty
            ImGui::TableSetColumnIndex(base + 1);

            if (selected_set)
                ImGui::TableSetBgColor(
                    ImGuiTableBgTarget_CellBg, cell_color);

            ImGui::Text("%d", line.dirty_);

            // tag
            ImGui::TableSetColumnIndex(base + 2);

            if (selected_set)
                ImGui::TableSetBgColor(
                    ImGuiTableBgTarget_CellBg, cell_color);

            ImGui::Text("0x%08X", line.tag_);

            // One selected word per way.
            ImGui::TableSetColumnIndex(base + 3);

            if (selected_set)
                ImGui::TableSetBgColor(
                    ImGuiTableBgTarget_CellBg, 
					cell_color
				);

            const int word = current_result_.word_index_;

            if (word >= 0 &&
                word < static_cast<int>(line.words_.size())) {
                ImGui::Text("0x%08X", line.words_[word]);
            } else {
                ImGui::TextDisabled("--------");
            }
        }
    }

    ImGui::EndTable();
}

