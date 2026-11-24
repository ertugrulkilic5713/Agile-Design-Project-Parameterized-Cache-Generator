#pragma once
#include "../defines.h"
#include <fstream>
#include <vector>
#include <string>
#include <sstream>

namespace Data {
	enum class Operation : u8 {
		READ = 0,
		WRITE = 1
	};

	struct Request {
		u32 addr;
		u32 data;
		u8 mask;
		Operation operation;

		inline std::string to_string() const {
			std::ostringstream oss;

			oss << "Request {\n"
				<< "  operation: " << (operation == Operation::READ ? "READ" : "WRITE") << "\n"
				<< "  addr:      0x" << std::hex << addr << "\n"
				<< "  data:      0x" << data << "\n"
				<< "  mask:      0x" << static_cast<int>(mask) << std::dec << "\n"
				<< "}";

			return oss.str();
		}
	};

	inline std::vector<Request> parse_workload_file(const std::string& path) {
		std::ifstream file(path);

        if (!file.is_open()) {
            throw std::runtime_error("Failed to open workload file: " + path);
        }

		char op;
		u32 addr, data, mask;
		std::vector<Request> requests;

		while (file >> op >> std::hex >> addr >> data >> mask) {
            if (op != 'R' && op != 'W') {
                throw std::runtime_error("Invalid workload operation");
            }

            if (mask > 0xF) {
                throw std::runtime_error("Invalid byte mask");
            }
			requests.push_back(Request{
				.addr = addr,
				.data = data,
				.mask = static_cast<u8>(mask),
				.operation = op == 'R'
					? Data::Operation::READ
					: Data::Operation::WRITE
			});
		}

        if (!file.eof()) {
            throw std::runtime_error("Malformed workload file");
        }

		return requests;
	}
}


