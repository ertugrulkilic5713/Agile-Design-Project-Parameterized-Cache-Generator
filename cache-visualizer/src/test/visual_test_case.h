#pragma once
#include "../data/requests.h"
#include "../data/responses.h"

struct TestCase {
    Data::Request request;
    Data::Response response;
};

inline TestCase visual_test(size_t i) {
    using namespace Data;

    static const std::vector<TestCase> tests = {
        // Read miss: address 0x00000000
        {
            .request = {
                .addr = 0x00000000,
                .operation = Operation::READ
            },
            .response = {
                .status = MISS,
                .way = 0,
                .data = 0x12345678,
                .latency = 20,
                .timestamp = 0
            }
        },

        // Read hit: same address
        {
            .request = {
                .addr = 0x00000000,
                .operation = Operation::READ
            },
            .response = {
                .status = HIT,
                .way = 0,
                .data = 0x12345678,
                .latency = 2,
                .timestamp = 20
            }
        },

        // Write hit
        {
            .request = {
                .addr = 0x00000004,
                .data = 0xDEADBEEF,
                .mask = 0xF,
                .operation = Operation::WRITE
            },
            .response = {
                .status = HIT,
                .way = 0,
                .data = 0,
                .latency = 2,
                .timestamp = 22
            }
        },

        // Read hit: previously written address
        {
            .request = {
                .addr = 0x00000004,
                .operation = Operation::READ
            },
            .response = {
                .status = HIT,
                .way = 0,
                .data = 0xDEADBEEF,
                .latency = 2,
                .timestamp = 24
            }
        },

        // Read miss: different set
        {
            .request = {
                .addr = 0x00000010,
                .operation = Operation::READ
            },
            .response = {
                .status = MISS,
                .way = 0,
                .data = 0xCAFEBABE,
                .latency = 20,
                .timestamp = 26
            }
        }
    };

    if (i >= tests.size())
        throw std::out_of_range("Test case index out of range");

    return tests[i];
}
