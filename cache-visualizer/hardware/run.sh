#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# default configuration
PORT=9000
CACHE_SIZE=4096
ADDR_WIDTH=32
LINE_BYTES=16
WORD_BYTES=4
MEM_BEAT_BYTES=4
ASSOCIATIVITY=4
REPLACEMENT=lru
WRITE_POLICY=write-back

while [[ $# -gt 0 ]]; do
    case "$1" in
        --port)           PORT="$2"; shift 2 ;;
        --cache-size)     CACHE_SIZE="$2"; shift 2 ;;
        --addr-width)     ADDR_WIDTH="$2"; shift 2 ;;
        --line-bytes)     LINE_BYTES="$2"; shift 2 ;;
        --word-bytes)     WORD_BYTES="$2"; shift 2 ;;
        --mem-beat-bytes) MEM_BEAT_BYTES="$2"; shift 2 ;;
        --associativity)  ASSOCIATIVITY="$2"; shift 2 ;;
        --replacement)    REPLACEMENT="$2"; shift 2 ;;
        --write-policy)   WRITE_POLICY="$2"; shift 2 ;;
        *)
            echo "Unknown argument: $1"
            exit 1
            ;;
    esac
done

echo "[Build] Compiling..."
sbt compile

exec sbt "runMain visualizer.Main \
    --port $PORT \
    --cache-size $CACHE_SIZE \
    --addr-width $ADDR_WIDTH \
    --line-bytes $LINE_BYTES \
    --word-bytes $WORD_BYTES \
    --mem-beat-bytes $MEM_BEAT_BYTES \
    --associativity $ASSOCIATIVITY \
    --replacement $REPLACEMENT \
    --write-policy $WRITE_POLICY"

