#pragma once
#include <string>
#include <cstdint>
#include <vector>
#include "../../defines.h"

/// connects to /dev/<device>
/// allows data to run through program and be parsed
class SerialPort {
public:
	SerialPort() = default;
	~SerialPort();

	bool open(const std::string& device, i32 baud);
	void close();
	bool is_open() const;
	bool write(const std::vector<u8>& data);
	i32 read(u8* buffer, size_t size);
private:
	int fd_ = -1;
};
