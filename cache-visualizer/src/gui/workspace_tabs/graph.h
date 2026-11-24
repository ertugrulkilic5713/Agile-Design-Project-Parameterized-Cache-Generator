#pragma once
#include "../../defines.h"

struct GraphPoint {
    f64 x;
    f64 y;
};

static std::vector<GraphPoint> get_hit_rate_points(
    const TestCase& tc
) {
    std::vector<GraphPoint> points;

    u64 hits = 0;

    for (usize i = 0; i < tc.resp.size(); i++) {
        if (tc.resp[i].status & Data::HIT)
            hits++;

        f64 rate =
            100.0 * static_cast<f64>(hits) / (i + 1);

        points.push_back({
            static_cast<f64>(i + 1),
            rate
        });
    }

    return points;
}

static std::vector<GraphPoint> get_latency_points(
    const TestCase& tc
) {
    std::vector<GraphPoint> points;

    if (tc.resp.empty())
        return points;

    u64 start_time = tc.resp.front().timestamp;

    for (usize i = 0; i < tc.resp.size(); i++) {
        const auto& response = tc.resp[i];

        points.push_back({
            static_cast<f64>(
                response.timestamp - start_time
            ),
            static_cast<f64>(response.latency)
        });
    }

    return points;
}
