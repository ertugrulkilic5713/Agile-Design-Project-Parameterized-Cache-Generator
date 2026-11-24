#pragma once

#include "../requests.h"
#include "../responses.h"
#include <vector>

namespace UART {

enum class Command : u8 {
    CONFIG          = 0x01,
    CONFIG_ACK      = 0x02,

    BEGIN_WORKLOAD  = 0x03,
    REQUEST         = 0x04,
    RESPONSE        = 0x05,

    END_WORKLOAD    = 0x06,
    WORKLOAD_DONE   = 0x07,

    GET_STATS       = 0x08,
    STATS           = 0x09,

    RESET           = 0x0A,
    ERROR           = 0xFF
};

struct Packet {
    Command command;
    std::vector<u8> payload;
};

std::vector<u8> encode_request(const Data::Request& request);

bool decode_response(
    const std::vector<u8>& payload,
    Data::Response& response
);

bool decode_statistics(
    const std::vector<u8>& payload,
    Data::Statistics& statistics
);

}

class ProtocolDecoder {
public:
    void push(const u8* data, size_t size);

    bool next(UART::Packet& packet);

private:
    std::vector<u8> buffer_;
};


