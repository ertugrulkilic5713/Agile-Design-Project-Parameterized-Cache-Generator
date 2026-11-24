#include "transact.h"
#include "net_socket/hardware_client.h"

Data::Response Data::socket_transact(
    i32 socket,
    const Data::Request& request
) {
    u8 tx[10]{};

	NetSocket::put_u32(&tx[0], request.addr);
    NetSocket::put_u32(&tx[4], request.data);

    tx[8] = request.mask;
    tx[9] = static_cast<u8>(request.operation);

    NetSocket::send_all(socket, tx, sizeof(tx));

    u8 rx[20]{};

    NetSocket::recv_all(socket, rx, sizeof(rx));

    Data::Response response{};

    response.status = rx[0];
    response.way = rx[1];
    response.data = NetSocket::get_u32(&rx[2]);

    response.latency =
        static_cast<u16>(rx[6]) |
        (static_cast<u16>(rx[7]) << 8);

    response.timestamp = NetSocket::get_u64(&rx[8]);
    response.evict_addr = NetSocket::get_u32(&rx[16]);

    return response;
}

std::vector<Data::Response> Data::socket_transact_batch(
    i32 socket,
    const std::vector<Data::Request>& requests
) {
    constexpr size_t REQUEST_SIZE = 10;
    constexpr size_t RESPONSE_SIZE = 20;

    if (requests.empty()) {
        return {};
    }

    // Serialize all requests.
    std::vector<u8> tx(requests.size() * REQUEST_SIZE);

    for (size_t i = 0; i < requests.size(); i++) {
        const auto& req = requests[i];

        u8* ptr = &tx[i * REQUEST_SIZE];

        NetSocket::put_u32(&ptr[0], req.addr);
        NetSocket::put_u32(&ptr[4], req.data);

        ptr[8] = req.mask;
        ptr[9] = static_cast<u8>(req.operation);
    }

    // Send all requests at once.
    NetSocket::send_all(socket, tx.data(), tx.size());

    // Receive all responses.
    std::vector<u8> rx(requests.size() * RESPONSE_SIZE);

    NetSocket::recv_all(socket, rx.data(), rx.size());

    // Deserialize responses.
    std::vector<Data::Response> responses;
    responses.reserve(requests.size());

    for (size_t i = 0; i < requests.size(); i++) {
        const u8* ptr = &rx[i * RESPONSE_SIZE];

        Data::Response response{};

        response.status = ptr[0];
        response.way = ptr[1];
        response.data = NetSocket::get_u32(&ptr[2]);

        response.latency =
            static_cast<u16>(ptr[6]) |
            (static_cast<u16>(ptr[7]) << 8);

        response.timestamp = NetSocket::get_u64(&ptr[8]);
        response.evict_addr = NetSocket::get_u32(&ptr[16]);

        responses.push_back(response);
    }

    return responses;
}
