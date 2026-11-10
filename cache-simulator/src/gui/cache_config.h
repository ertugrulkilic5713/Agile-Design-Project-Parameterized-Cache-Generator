#pragma once
#include "../defines.h"

// configuration data
enum class ReplacementPolicy { LRU, PLRU };
enum class WritePolicy { WriteBack, WriteThrough }; // did we add this yet?

struct CacheConfig {
	// default configuration from HDL
	u32 cache_size_ = 4096; // capacityBytes in hardware, confusing to me though
	u32 addr_width_ = 32;
	u32 line_bytes_ = 16; // one cache line (block)
	u32 word_bytes_ = 4; // width of the CPU-side repsonse
	u32 mem_beat_bytes_ = 4;
	u32 associativity_ = 4; // TODO: not defined in current cache impl
	ReplacementPolicy replacement_ = ReplacementPolicy::LRU;
	WritePolicy write_policy_ = WritePolicy::WriteBack;
	// maybe enable_debug to compile in or out uart?

	uint32_t num_sets() const {
		uint32_t d = line_bytes_ * associativity_;
		return d ? cache_size_ / d : 0;
	}
};

// gui panel
class CacheConfigPanel {
public:
	void render();

	void set_config(const CacheConfig& c) { config_ = c; }
	const CacheConfig& get_config() const { return config_; }

	// only update if changed
	inline bool has_changed() { bool c = changed_; changed_ = false; return c; }
private:
	CacheConfig config_;
	bool changed_ = false;
};
