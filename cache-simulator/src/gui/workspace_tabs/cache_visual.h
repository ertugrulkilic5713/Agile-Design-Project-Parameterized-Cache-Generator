#pragma once
#include "../../defines.h"
#include <optional>
#include <vector>

struct CacheLookupResult {
    bool hit_ = false;

    // Address decomposition.
    u32 tag_ = 0;
    int set_ = -1;
    int offset_ = 0;
    int word_index_ = -1;

    // Lookup result.
    int way_ = -1; // -1 on miss
    int victim_way_ = -1; // replacement way
    bool evicted_ = false; // a valid line was replaced
    bool writeback_ = false; // that line was dirty
};

struct CacheRequest {
    u32 addr_ = 0;

    bool rd_ = false;
    bool wr_ = false;

    u32 wrdata_ = 0;
};

struct CacheLine {
    bool valid_ = false;
    bool dirty_ = false;
    u32 tag_ = 0;

    // data storage
    std::vector<u32> words_;
};

struct CacheSnapshot {
    int sets_ = 0;
    int ways_ = 0;

    int line_bytes_ = 16;
    int words_per_line_ = 4;

    int index_bits_ = 0;
    int offset_bits_ = 4;

    // [set index][way]
    std::vector<std::vector<CacheLine>> cache_;

    // access a particular cache line (read).
    const CacheLine& at(int set, int way) const {
        return cache_.at(set).at(way);
    }

    // access a particular cache line (write).
    CacheLine& at(int set, int way) {
        return cache_.at(set).at(way);
    }

    // returns the matching way, or nullopt on a miss.
    std::optional<int> find(int set, uint32_t tag) const {
        for (int way = 0; way < ways_; ++way) {
            const auto& line = at(set, way);

            if (line.valid_ && line.tag_ == tag)
                return way;
        }

        return std::nullopt;
    }

    // decompose an address into tag, index and offset.
    CacheLookupResult lookup(uint32_t addr) const {
        if (sets_ <= 0 || ways_ <= 0 ||
            index_bits_ < 0 || index_bits_ >= 32 ||
            offset_bits_ < 0 ||
            index_bits_ + offset_bits_ >= 32) {
            throw std::logic_error("Invalid cache configuration");
        }

        CacheLookupResult result;

        const uint32_t index_mask =
            (1u << index_bits_) - 1;

        const uint32_t offset_mask =
            (1u << offset_bits_) - 1;

        result.set_ =
            (addr >> offset_bits_) & index_mask;

        result.offset_ =
            addr & offset_mask;

        result.tag_ =
            addr >> (index_bits_ + offset_bits_);

        result.word_index_ =
            result.offset_ / sizeof(u32);

        auto way = find(result.set_, result.tag_);

        if (way.has_value()) {
            result.hit_ = true;
            result.way_ = *way;
        }

        return result;
    }
};
class CacheVisual {
public:
	void render();
	
	inline void set_line(u32 search_index, u32 search_way) { search_index_ = search_index; search_way_ = search_way; }
	inline void set_cache(CacheSnapshot* cache) { cache_ = cache; }
	inline void set_result(const CacheLookupResult& result) { current_result_ = result; }
private:
	CacheSnapshot* cache_ = nullptr;
	u32 search_index_ = -1;
	u32 search_way_ = -1;
	CacheLookupResult current_result_;
};

