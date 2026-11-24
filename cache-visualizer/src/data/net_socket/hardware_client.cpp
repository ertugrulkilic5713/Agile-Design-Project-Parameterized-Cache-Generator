#include "hardware_client.h"
#include <cstdint>
#include <cstring>
#include <sys/socket.h>
#include <cerrno>
#include <stdexcept>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <unistd.h>
#include <netinet/tcp.h>
#include <thread>
#include <chrono>

pid_t NetSocket::start_simulator(const CacheConfig& config) {
	const std::string cache_size = std::to_string(config.cache_size_);
	const std::string addr_width = std::to_string(config.addr_width_);
	const std::string line_bytes = std::to_string(config.line_bytes_);
	const std::string word_bytes = std::to_string(config.word_bytes_);
	const std::string mem_beat_bytes = std::to_string(config.mem_beat_bytes_);
	const std::string associativity = std::to_string(config.associativity_);

	const std::string replacement =
		config.replacement_ == ReplacementPolicy::LRU ? "lru" : "plru";

	const std::string write_policy =
		config.write_policy_ == WritePolicy::WriteBack
			? "write-back"
			: "write-through";

    pid_t pid = fork();

    if (pid < 0) {
        throw std::runtime_error("Failed to launch simulator");
    }

    if (pid == 0) {
		execl(
			"./hardware/run.sh",
			"./hardware/run.sh",
			"--port", "9000",
			"--cache-size", cache_size.c_str(),
			"--addr-width", addr_width.c_str(),
			"--line-bytes", line_bytes.c_str(),
			"--word-bytes", word_bytes.c_str(),
			"--mem-beat-bytes", mem_beat_bytes.c_str(),
			"--associativity", associativity.c_str(),
			"--replacement", replacement.c_str(),
			"--write-policy", write_policy.c_str(),
			nullptr
		);

		perror("execl failed");
        _exit(127);
    }

    return pid;
}

i32 NetSocket::wait_for_server(
    const char* host,
    u16 port,
    i32 timeout_seconds
) {
    auto deadline = std::chrono::steady_clock::now()
        + std::chrono::seconds(timeout_seconds);

    while (std::chrono::steady_clock::now() < deadline) {
        i32 socket = connect_to_server(host, port);

        if (socket >= 0) {
            return socket;
        }

        std::this_thread::sleep_for(
            std::chrono::milliseconds(100)
        );
    }

    return -1;
}

i32 NetSocket::connect_to_server(
    const std::string& host,
    i32 port
) {
    int sock = ::socket(AF_INET, SOCK_STREAM, 0);

    if (sock < 0)
        return -1;

	int flag = 1;

	setsockopt(
		sock,
		IPPROTO_TCP,
		TCP_NODELAY,
		&flag,
		sizeof(flag)
	);

    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);

    if (inet_pton(AF_INET, host.c_str(), &addr.sin_addr) <= 0) {
        ::close(sock);
        return -1;
    }

    if (::connect(
        sock,
        reinterpret_cast<sockaddr*>(&addr),
        sizeof(addr)
    ) < 0) {
        ::close(sock);
        return -1;
    }

    return sock;
}

void NetSocket::close_socket(i32 socket) {
    if (socket >= 0) {
        ::close(socket);
    }
}

void NetSocket::send_all(int socket, const u8* data, size_t size) {
    size_t sent = 0;

    while (sent < size) {
        ssize_t n = send(socket, data + sent, size - sent, 0);

        if (n < 0 && errno == EINTR)
            continue;

        if (n <= 0)
            throw std::runtime_error("Socket send failed");

        sent += static_cast<size_t>(n);
    }
}

void NetSocket::recv_all(int socket, u8* data, size_t size) {
    size_t received = 0;

    while (received < size) {
        ssize_t n = recv(
            socket,
            data + received,
            size - received,
            0
        );

        if (n < 0 && errno == EINTR)
            continue;

        if (n <= 0)
            throw std::runtime_error("Socket receive failed");

        received += static_cast<size_t>(n);
    }
}

void NetSocket::put_u32(u8* b, u32 v) {
    for (int i = 0; i < 4; ++i)
        b[i] = static_cast<u8>(v >> (i * 8));
}

u32 NetSocket::get_u32(const u8* b) {
    return
        static_cast<u32>(b[0]) |
        (static_cast<u32>(b[1]) << 8) |
        (static_cast<u32>(b[2]) << 16) |
        (static_cast<u32>(b[3]) << 24);
}

u64 NetSocket::get_u64(const u8* b) {
    u64 value = 0;

    for (int i = 0; i < 8; ++i)
        value |= static_cast<u64>(b[i]) << (i * 8);

    return value;
}
