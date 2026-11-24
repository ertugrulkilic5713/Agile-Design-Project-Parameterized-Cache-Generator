#pragma once
#include "../defines.h"
#include "../data/cache_config.h"

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
	u8 load_to_ = 0; // 1 for board, 2 for simulation
};
