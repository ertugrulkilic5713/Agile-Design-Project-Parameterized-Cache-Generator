#pragma once
#include "../../defines.h"
#include <optional>
#include <vector>
#include "../../data/cache_config.h"
#include "../../data/requests.h"
#include "../../data/responses.h"

struct CacheLineState {
	u32 tag = 0;
	bool valid = false;
	bool dirty = false;
	std::vector<u32> words;
};

class CacheVisual {
public:
	// called first
	void configure(const CacheConfig& cache);
	void render();
	void apply(const Data::Request& request, const Data::Response& response);
	void reset();
private:
	std::vector<std::vector<CacheLineState>> lines_;

    int sets_ = 0;
    int ways_ = 0;

    int line_bytes_ = 0;
	int word_bytes_ = 0;
    int words_per_line_ = 0;

    int index_bits_ = 0;
    int offset_bits_ = 0;

    int selected_set_ = -1;
    int selected_way_ = -1;
    int selected_word_ = -1;

	// for specific highlighting
    bool valid_changed_ = false;
    bool dirty_changed_ = false;
    bool word_changed_ = false;

    Data::Response current_response_;
	WritePolicy cache_write_policy_ = WritePolicy::WriteBack;
};

