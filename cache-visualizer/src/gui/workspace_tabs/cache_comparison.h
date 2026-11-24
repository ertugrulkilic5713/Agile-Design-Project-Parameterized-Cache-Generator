#pragma once

#include <optional>
#include <string>
#include <vector>
#include <cstddef>
#include "../../defines.h"
#include "../../data/cache_config.h"
#include "../../test_case_ds.h"

// each run holds single config, with multiple datasets run for it
struct CacheComparisonConfigRun {
	std::string id;
    std::string name;
	
	CacheConfig config;
	std::vector<TestCase> datasets;

    inline u64 total_accesses() const {
        u64 total = 0;
        for (const auto& ds : datasets)
            total += ds.accesses();
        return total;
    }

    inline u64 total_hits() const {
        u64 total = 0;
        for (const auto& ds : datasets)
            total += ds.hits;
        return total;
    }

    inline u64 total_misses() const {
        u64 total = 0;
        for (const auto& ds : datasets)
            total += ds.misses;
        return total;
    }

	inline f64 total_hit_rate() const {
		return total_accesses() == 0
			? 0.0
			: 100.0 * total_hits() / total_accesses();
	}

	inline f64 avg_latency_ns() const {
		return total_accesses() == 0
			? 0.0
			: total_latency_ns() / total_accesses();
	}

	inline f64 total_time_ns() const {
		f64 total = 0.0;
		for (const auto& ds : datasets)
			total += ds.total_time_ns();

		return total;
	}

	inline f64 total_latency_ns() const {
		f64 total = 0.0;
		for (const auto& ds : datasets)
			total += ds.total_latency_ns;

		return total;
	}
};

enum class CacheComparisonSort {
    HitRate,
    MissRate,
    AvgLatency,
    TotalTime
};

class CacheComparison {
public:
    void clear();

	// add or return exisitng config
	CacheComparisonConfigRun& add_config(const CacheConfig& config);

	// add to existing config 
	bool add_data_set(const CacheConfig& config, TestCase dataset);

    // Find an existing configuration.
    CacheComparisonConfigRun* find_config(const CacheConfig& config);

    void render();

	inline std::optional<CacheConfig> get_config() {
		if (load_config_)  {
			load_config_ = false;
			return runs_[selected_config_].config;
		}
		return std::nullopt;
	}


private:
    std::vector<CacheComparisonConfigRun> runs_;

	bool load_config_ = false;
	usize selected_config_ = 0;

	void render_toolbar();
	void render_run(const CacheComparisonConfigRun& run, usize index);
	void render_hit_rate_graph(const CacheComparisonConfigRun& run);
	void render_latency_graph(const CacheComparisonConfigRun& run);
};

