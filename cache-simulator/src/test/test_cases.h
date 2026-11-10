#pragma once
#include <string>
#include "../gui/workspace_tabs/cache_visual.h"

namespace Test {

	// Configure + reset the cache (4 sets, 2 ways, 16B lines).
	void test_cache_impl(CacheSnapshot& cache);

	int test_case_count();

	// Executes one scripted access: lookup, allocate on miss, apply write.
	void run_test_case(
		int idx,
		CacheSnapshot& cache,
		CacheRequest& req,
		CacheLookupResult& result,
		std::string* description
	);

} // namespace Test
