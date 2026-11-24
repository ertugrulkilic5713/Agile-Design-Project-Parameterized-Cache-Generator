#include "uart_controller.h"

// void UARTController::listen() {
//     u8 buffer[256];
//
//     while (running_) {
//         int n = serial_.read(buffer, sizeof(buffer));
//
//         if (n > 0) {
//             decoder_.push(buffer, n);
//
//             UART::Packet packet;
//
//             while (decoder_.next(packet)) {
//                 switch (packet.command) {
//                     case UART::Command::RESPONSE: {
//                         Data::Response response;
//
//                         if (UART::decode_response(
//                             packet.payload, response
//                         )) {
//                             std::lock_guard lock(response_mutex_);
//                             responses_.push(response);
//                         }
//                         break;
//                     }
//
//                     case UART::Command::STATS: {
//                         Data::Statistics stats;
//
//                         if (UART::decode_statistics(
//                             packet.payload, stats
//                         )) {
//                             std::lock_guard lock(response_mutex_);
//                             statistics_.push(stats);
//                         }
//                         break;
//                     }
//
//                     default:
//                         break;
//                 }
//             }
//         }
//     }
// }
