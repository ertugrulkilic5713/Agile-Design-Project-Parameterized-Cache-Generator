#include "cache_visual.h"
#include "../widgets.h"
#include <iostream>
#include <string>
#include <bit>
#include <stdexcept>
#include "../../data/cache_config.h"

void CacheVisual::configure(const CacheConfig& cache) {
    if (cache.cache_size_ == 0 ||
        cache.line_bytes_ == 0 ||
        cache.word_bytes_ == 0 ||
        cache.associativity_ == 0) {
        throw std::invalid_argument("Invalid cache configuration");
    }

    if (cache.cache_size_ % (cache.line_bytes_ * cache.associativity_) != 0) {
        throw std::invalid_argument(
            "Cache size must be divisible by line size * associativity"
        );
    }

    if ((cache.line_bytes_ & (cache.line_bytes_ - 1)) != 0 ||
        (cache.num_sets() & (cache.num_sets() - 1)) != 0) {
        throw std::invalid_argument(
            "Line size and number of sets must be powers of two"
        );
    }

    if (cache.line_bytes_ % cache.word_bytes_ != 0) {
        throw std::invalid_argument(
            "Line size must be divisible by word size"
        );
    }

    if (cache.word_bytes_ != sizeof(u32)) {
        throw std::invalid_argument(
            "CacheVisual currently supports 32-bit words only"
        );
    }

    sets_ = cache.num_sets();
    ways_ = cache.associativity_;

    line_bytes_ = cache.line_bytes_;
    word_bytes_ = cache.word_bytes_;

    words_per_line_ = line_bytes_ / word_bytes_;

    index_bits_ = std::countr_zero(
        static_cast<unsigned>(sets_)
    );

    offset_bits_ = std::countr_zero(
        static_cast<unsigned>(line_bytes_)
    );

    lines_.assign(
        sets_,
        std::vector<CacheLineState>(ways_)
    );

    for (auto& set : lines_) {
        for (auto& line : set) {
            line.words.assign(words_per_line_, 0);
        }
    }

    selected_set_ = -1;
    selected_way_ = -1;
    selected_word_ = -1;

    current_response_ = {};
}

void CacheVisual::apply(
    const Data::Request& request,
    const Data::Response& response
) {
    if (lines_.empty() || response.way >= ways_)
        return;

    if (response.way >= ways_) {
        std::cerr << "[CacheVisual] Invalid way: "
                  << static_cast<int>(response.way)
                  << " (ways=" << ways_ << ")\n";
        return;
    }

    const u32 set_mask = sets_ - 1;
    const u32 offset_mask = line_bytes_ - 1;

    const int set = (request.addr >> offset_bits_) & set_mask;
    const u32 tag = request.addr >> (index_bits_ + offset_bits_);
    const int word_index = (request.addr & offset_mask) / word_bytes_;

    if (set >= sets_ || word_index >= words_per_line_)
        return;

    auto& line = lines_[set][response.way];

    const bool miss = response.status & Data::MISS;

    // Snapshot before modifying.
    const bool old_valid = line.valid;
    const bool old_dirty = line.dirty;
    const u32  old_word  = line.words[word_index];

    // Any miss replaces the line (evicting or filling a cold line).
    if (miss) {
        line.dirty = false;
        std::fill(line.words.begin(), line.words.end(), 0);
    }

    line.valid = true;
    line.tag = tag;

    if (request.operation == Data::Operation::READ) {
        line.words[word_index] = response.data;
    }
    else {
        for (int byte = 0; byte < word_bytes_; ++byte) {
            if (request.mask & (1u << byte)) {
                const u32 mask = 0xFFu << (byte * 8);
                line.words[word_index] =
                    (line.words[word_index] & ~mask) |
                    (request.data & mask);
            }
        }

        if (cache_write_policy_ == WritePolicy::WriteBack)
            line.dirty = true;
    }

    selected_set_  = set;
    selected_way_  = response.way;
    selected_word_ = word_index;

    valid_changed_ = line.valid != old_valid;
    dirty_changed_ = line.dirty != old_dirty;
    word_changed_  = line.words[word_index] != old_word;

    current_response_ = response;
}

void CacheVisual::render() {
    if (lines_.empty())
        return;

    if (!ImGui::BeginTable(
        "CacheTable",
        1 + ways_ * (2 + words_per_line_),
        ImGuiTableFlags_Borders |
        ImGuiTableFlags_RowBg |
        ImGuiTableFlags_ScrollX |
        ImGuiTableFlags_ScrollY |
        ImGuiTableFlags_Resizable
    )) {
        return;
    }

    const bool hit  = (current_response_.status & Data::HIT) != 0;
    const bool miss = (current_response_.status & Data::MISS) != 0;

    // Row = one color, column = another.
    constexpr ImU32 row_color    = IM_COL32(30, 170, 160, 55);   // orange
    constexpr ImU32 column_color = IM_COL32(30, 170, 160, 55);   // teal

    // Changed value: red on hit, green on miss (swap here if you want the reverse).
    const ImU32 result_color = hit
        ? IM_COL32(30, 180, 80, 200)     // hit  -> red
        : miss
            ? IM_COL32(210, 45, 45, 200) // miss -> green
            : IM_COL32(65, 125, 180, 160);

    ImGui::TableSetupScrollFreeze(1, 1);
    ImGui::TableSetupColumn("Set");

    for (int way = 0; way < ways_; ++way) {
        const std::string w = "W" + std::to_string(way);
        ImGui::TableSetupColumn((w + " Valid").c_str());
        ImGui::TableSetupColumn((w + " Dirty").c_str());
        for (int word = 0; word < words_per_line_; ++word) {
            ImGui::TableSetupColumn(
                (w + " Word " + std::to_string(word)).c_str()
            );
        }
    }

    ImGui::TableHeadersRow();

    for (int set = 0; set < sets_; ++set) {
        ImGui::TableNextRow();

        const bool selected_row = set == selected_set_;

        if (selected_row) {
            ImGui::TableSetBgColor(ImGuiTableBgTarget_RowBg0, row_color);
        }

        ImGui::TableNextColumn();
        ImGui::Text("%d", set);

        for (int way = 0; way < ways_; ++way) {
            const auto& line = lines_[set][way];
            const bool selected_way = way == selected_way_;
            const bool selected_line = selected_row && selected_way;

            // Valid
            ImGui::TableNextColumn();
            if (selected_line && valid_changed_)
                ImGui::TableSetBgColor(ImGuiTableBgTarget_CellBg, result_color);
            ImGui::Text("%d", line.valid);

            // Dirty
            ImGui::TableNextColumn();
            if (selected_line && dirty_changed_)
                ImGui::TableSetBgColor(ImGuiTableBgTarget_CellBg, result_color);
            ImGui::Text("%d", line.dirty);

            // Words
            for (int word = 0; word < words_per_line_; ++word) {
                ImGui::TableNextColumn();

                const bool in_column = selected_way && word == selected_word_;

                if (selected_row && in_column) {
                    // The accessed word itself.
                    ImGui::TableSetBgColor(ImGuiTableBgTarget_CellBg, result_color);
                }
                else if (in_column) {
                    // Rest of the selected word's column.
                    ImGui::TableSetBgColor(ImGuiTableBgTarget_CellBg, column_color);
                }

                ImGui::Text("%08X", line.words[word]);
            }
        }
    }

    ImGui::EndTable();
}

void CacheVisual::reset() {
	lines_.clear();
	sets_ = 0;
	ways_ = 0;
	line_bytes_ = 0;
	word_bytes_ = 0;
	words_per_line_ = 0;
	index_bits_ = 0;
	offset_bits_ = 0;
	selected_set_ = -1;
	selected_way_ = -1;
	selected_word_ = -1;
	valid_changed_ = false;
	dirty_changed_ = false;
	word_changed_ = false;
	current_response_ = {};
	cache_write_policy_ = WritePolicy::WriteBack;
}
