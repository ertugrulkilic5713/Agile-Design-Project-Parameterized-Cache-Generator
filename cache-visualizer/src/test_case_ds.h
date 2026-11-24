#pragma once
#include "data/requests.h"
#include "data/responses.h"
#include "defines.h"

// each test case is an array of req and resp
struct TestCase {
	std::string name = "Untitled";

    std::vector<Data::Request> req;
    std::vector<Data::Response> resp;

    // Aggregate metrics
    u64 hits = 0;
    u64 misses = 0;
    u64 reads = 0;
    u64 writes = 0;
    u64 read_hits = 0;
    u64 write_hits = 0;
    u64 evictions = 0;
    u64 writebacks = 0;
    u64 write_throughs = 0;

    u64 total_latency_ns = 0;
    u64 min_latency_ns = UINT64_MAX;
    u64 max_latency_ns = 0;

    // Derived metrics
    inline u64 accesses() const {
        return hits + misses;
    }

    inline f64 hit_rate() const {
        return accesses() == 0
            ? 0.0
            : 100.0 * hits / accesses();
    }

    inline f64 miss_rate() const {
        return accesses() == 0
            ? 0.0
            : 100.0 * misses / accesses();
    }

    inline f64 avg_latency_ns() const {
        return accesses() == 0
            ? 0.0
            : static_cast<f64>(total_latency_ns) / accesses();
    }

    inline u64 total_time_ns() const {
        if (resp.size() < 2)
            return 0;

        return resp.back().timestamp - resp.front().timestamp;
    }
};
