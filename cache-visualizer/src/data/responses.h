#pragma once

#include "../defines.h"
#include "requests.h"
#include <string>
#include <sstream>

namespace Data {

	enum ResponseStatusMask : u8 {
		HIT           = 1 << 0,
		MISS          = 1 << 1,
		WRITE_BACK    = 1 << 2,
		WRITE_THROUGH = 1 << 3,
		IS_WRITE      = 1 << 4,
		EVICT         = 1 << 5,
		EVICT_DIRTY   = 1 << 6
	};

    struct Response {
		u8 status;
		u8 way;
		u32 data;
		u16 latency;
		u64 timestamp;
		u32 evict_addr;

		inline std::string to_string() const {
			std::ostringstream oss;

			oss << "Response {\n"
				<< "  status:     " << static_cast<int>(status) << "\n"
				<< "  way:        " << static_cast<int>(way) << "\n"
				<< "  data:       0x" << std::hex << data << std::dec << "\n"
				<< "  latency:    " << latency << "\n"
				<< "  timestamp:  " << timestamp << "\n"
				<< "  evict_addr: 0x" << std::hex << evict_addr << std::dec << "\n"
				<< "}";

			return oss.str();
		}
    };

	struct Statistics {
		u64 total_requests;
		u64 reads;
		u64 writes;

		u64 hits;
		u64 misses;
		u64 evictions;
		u64 writebacks;

		u64 total_cycles;
		u64 stall_cycles;
	};

	inline std::vector<Response> parse_response_file(
		const std::string& path
	) {
		std::ifstream file(path);

		if (!file.is_open()) {
			throw std::runtime_error("Failed to open response file: " + path);
		}

		u32 status, way, data, latency, evictAddr;
		u64 timestamp;

		std::vector<Response> responses;

		while (file >> std::hex
					>> status
					>> way
					>> data
					>> latency
					>> timestamp
					>> evictAddr) {

			responses.push_back(Response{
				.status = static_cast<u8>(status),
				.way = static_cast<u8>(way),
				.data = data,
				.latency = static_cast<u16>(latency),
				.timestamp = timestamp,
				.evict_addr = evictAddr
			});
		}

		if (!file.eof()) {
			throw std::runtime_error("Malformed response file");
		}

		return responses;
	}

}
