# Architecture
Request: `[ Address (4B) ][ Data (4B) ][ Mask (1B) ][ Operation (1B) ]`
- Operation is 0 = Read, 1 = Write

Response: `[ Status (1B) ][ Way (1B) ][ Data (4B) ][ Latency (2B) ][ Timestamp (8B) ][ Evict Address (4B) ]`
- Status:
| Status Flag   | Binary       | Hex    |
| ------------- | ------------ | ------ |
| Hit           | `0b00000001` | `0x01` |
| Miss          | `0b00000010` | `0x02` |
| Write Back    | `0b00000100` | `0x04` |
| Write Through | `0b00001000` | `0x08` |
| Is Write      | `0b00010000` | `0x10` |
| Evict         | `0b00100000` | `0x20` |
| Evict Dirty   | `0b01000000` | `0x40` |

# Build
```bash
make run
```

# Fixes
## Server Dont connect
```bash
lsof -i :9000
kill <pid>
```

