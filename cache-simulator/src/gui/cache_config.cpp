#include "cache_config.h"
#include "widgets.h"

// for gui selection boxes
const u32 CACHE_SIZE[]  = {1024, 2048, 4096, 8192, 16384, 32768, 65536};
const char* const CACHE_SIZE_LABELS[] = {
	"1 KB", "2 KB", "4 KB", "8 KB", "16 KB", "32 KB", "64 KB"
};

const u32 ADDR_WIDTH[] = {16, 32, 64};
const char* const ADDR_WIDTH_LABELS[] = {
    "16-bit", "32-bit", "64-bit"
};

const u32 LINE_BYTES[] = {4, 8, 16, 32, 64, 128};
const char* const LINE_BYTES_LABELS[] = {
    "4 B", "8 B", "16 B", "32 B", "64 B", "128 B"
};

const u32 WORD_BYTES[] = {1, 2, 4, 8};
const char* const WORD_BYTES_LABELS[] = {
    "1 B (8-bit)", "2 B (16-bit)", "4 B (32-bit)", "8 B (64-bit)"
};

const u32 MEM_BEAT_BYTES[] = {1, 2, 4, 8, 16};
const char* const MEM_BEAT_BYTES_LABELS[] = {
    "1 B", "2 B", "4 B", "8 B", "16 B"
};

const u32 ASSOCIATIVE_WAYS[] = {1, 2, 4, 8, 16};
const char* const ASSOCIATIVE_WAYS_LABELS[] = {
	"Direct", "2-way", "4-way", "8-way", "16-way"
};
const char* const REPLACEMENT[]  = {
	"PLRU", "LRU"
};

const char* const WRITE_POLICY[] = {"Write Though", "Write Bacl"};

// helper generator: search for string comparison
template <size_t N>
int index_of(const u32 (&a)[N], u32 v) {
	for (size_t i = 0; i < N; ++i) if (a[i] == v) return (int)i;
	return 0;
}


void CacheConfigPanel::render() {
	SectionHeader("Cache Configuration");

	// gets ids used to display current selection
	int idx_size = index_of(CACHE_SIZE, config_.cache_size_);
	int idx_addr_width = index_of(ADDR_WIDTH, config_.addr_width_);
	int idx_line_bytes = index_of(LINE_BYTES, config_.line_bytes_);
	int idx_word_bytes = index_of(WORD_BYTES, config_.word_bytes_);
	int idx_mem_beat_bytes = index_of(MEM_BEAT_BYTES, config_.mem_beat_bytes_);
	int idx_associativity = index_of(ASSOCIATIVE_WAYS, config_.associativity_);
	int idx_replacement = (int)config_.replacement_;
	int idx_write_policy = (int)config_.write_policy_;

	LabeledRow("Cache Size");
	if (ComboStr("##size",  idx_size,  CACHE_SIZE_LABELS))  { 
		config_.cache_size_ = CACHE_SIZE[idx_size];
		changed_ = true;
	}
	LabeledRow("Address Width");
	if (ComboStr("##addr", idx_addr_width, ADDR_WIDTH_LABELS)) { 
		config_.addr_width_ = ADDR_WIDTH[idx_addr_width];
		changed_ = true;
	}
	LabeledRow("Line Bytes");
	if (ComboStr("##line_byte", idx_line_bytes, LINE_BYTES_LABELS)) { 
		config_.line_bytes_ = LINE_BYTES[idx_line_bytes];
		changed_ = true;
	}
	LabeledRow("Word Bytes");
	if (ComboStr("##word", idx_word_bytes, WORD_BYTES_LABELS)) { 
		config_.word_bytes_ = WORD_BYTES[idx_word_bytes];
		changed_ = true;
	}
	LabeledRow("Mem Beat Bytes");
	if (ComboStr("##mem_beat", idx_mem_beat_bytes, MEM_BEAT_BYTES_LABELS)) { 
		config_.mem_beat_bytes_ = MEM_BEAT_BYTES[idx_mem_beat_bytes];
		changed_ = true;
	}
	LabeledRow("Associative Ways");
	if (ComboStr("##assoc", idx_associativity, ASSOCIATIVE_WAYS_LABELS)) { 
		config_.associativity_ = ASSOCIATIVE_WAYS[idx_associativity];
		changed_ = true;
	}
	LabeledRow("Replacement");
	if (ComboStr("##repl", idx_replacement, REPLACEMENT)) { 
		config_.replacement_ = (ReplacementPolicy)idx_replacement;
		changed_ = true;
	}
	LabeledRow("Write Policy");
	if (ComboStr("##write_policy", idx_write_policy, WRITE_POLICY)) { 
		config_.write_policy_ = (WritePolicy)idx_write_policy;
		changed_ = true;
	}

	// if necessary
	// changed_ |= ImGui::Checkbox("Enable Debug", &cfg_.enable_debug);

	// ensures correctness
	if (config_.num_sets() == 0) {
		ImGui::TextColored(
			ImVec4(1, 0.4f, 0.4f, 1), 
			"Invalid: cache smaller than one set"
		);
	}
}
