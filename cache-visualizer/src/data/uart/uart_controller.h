#pragma once

#include "serial_port.h"
#include "../cache_config.h"

#include <thread>
#include <atomic>
#include <mutex>
#include <queue>

// class UARTController {
// public:
//     bool connect(const std::string& device, int baud);
//     void disconnect();
//
//     void send_request(const Data::Request& request);
//     void send_config(const CacheConfig& config);
//     void begin_workload();
//     void end_workload();
//
//     bool poll_response(Data::Response& response);
//     bool poll_statistics(Data::Statistics& statistics);
//
// private:
//     void listen();
//
//     SerialPort serial_;
//     ProtocolDecoder decoder_;
//
//     std::thread listener_;
//     std::atomic<bool> running_{false};
//
//     std::mutex response_mutex_;
//
//     std::queue<Data::Response> responses_;
//     std::queue<Data::Statistics> statistics_;
// };
