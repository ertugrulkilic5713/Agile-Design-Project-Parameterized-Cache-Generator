# Adapter for "schoeberl/wildcat"
CacheAdapter connects the Wildcat CPU to our custom Cache Generator. The CPU
utilizes [PipeCon](https://github.com/t-crest/soc-comm), which with this 
implementation has been repurposed, with the same functionality, to communicate 
with our more extensive memory mapped cache protocols. This cache is made to look
like the other PipeCon device.

## Why the adapter is needed
PipeCon only supplies a minimal memory-mapped protocol that is sufficient for 
more basic and smaller implementations, but it runs into flaws:
- its one-cycle pulse is lost if the cache isnt ready
- a miss requires a while line from emmory and pipecon can only process a word 
  at a time
The adapter handles both of these

## Structure
Cache Adapter extends PipeConDevice(32) which provides CPU facing io port while
providing both cache and memory port. Together, a finite state machine can handle
read/write requests, aquire memory from the cache, and

## Implementation
// todo
