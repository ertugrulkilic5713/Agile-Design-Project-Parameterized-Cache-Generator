#pragma once 
#include "requests.h"
#include "responses.h"
#include <vector>

// Send request, get response to hardware
namespace Data {
	// send response to simulated hardware
	Response socket_transact(i32 socket, const Data::Request& request);
	std::vector<Response> socket_transact_batch(
		i32 socket,
		const std::vector<Request>& requests
	);
}
