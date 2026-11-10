#pragma once
#include "../defines.h"
#include "workspace_tabs/cache_visual.h"

struct CacheTiming {
    u32 hit_cycles = 1;
    u32 miss_penalty = 100;       // extra cycles to fetch the line
    u32 writeback_penalty = 100;  // extra cycles to write back a dirty victim
};

struct CacheStats {
	u64 hits = 0, misses = 0, evictions = 0, writebacks = 0, total_cycles = 0;

	inline u64 accesses() const { return hits + misses; }
	inline f64 hit_rate()   const { return accesses() ? (f64)hits   / accesses() : 0.0; }
	inline f64 miss_rate()  const { return accesses() ? (f64)misses / accesses() : 0.0; }
	inline f64 avg_latency() const { return accesses() ? (f64)total_cycles / accesses() : 0.0; }

	// stores new updates from cache file
    void record(const CacheLookupResult& r, const CacheTiming& t) {
        total_cycles += t.hit_cycles;  // every access pays the lookup

        if (r.hit_) {
            ++hits;
            return;
        }

        misses++;
        total_cycles += t.miss_penalty;

        if (r.evicted_) evictions++;
        if (r.writeback_) {
            writebacks++;
            total_cycles += t.writeback_penalty;
		}
	}
};


class StatisticsPanel {
public:
	void render();

	void set_stats(const CacheStats& s) { stats_ = s; }
	const CacheStats& get_stats() const { return stats_; }
	void update_stats(const CacheLookupResult& r, const CacheTiming& t) {
		stats_.record(r, t); 
	}
private:
	CacheStats stats_;
};
