#pragma once
#include "../../defines.h"
#include "../cache_config.h"
#include <string>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

// allows local network connection for recieving and sending packets
/*
	start_simulator then call wait_for_server. returns socket to go to connect and close.
	do for each unique configuration
*/
namespace NetSocket {
	pid_t start_simulator(const CacheConfig& config);
	i32 wait_for_server(const char* host, u16 port, i32 timeout_seconds);
	i32 connect_to_server(const std::string& addr, i32 socket);
	void close_socket(i32 socket);
	void send_all(int socket, const u8* data, size_t size);
	void recv_all(int socket, u8* data, size_t size);
	void put_u32(u8* b, u32 v);
	u32 get_u32(const u8* b);
	u64 get_u64(const u8* b);
}
