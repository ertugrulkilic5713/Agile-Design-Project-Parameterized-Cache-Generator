import serial, struct

ser = serial.Serial("/dev/ttyUSB1", 115200)
while True:
    if ser.read(1) != b"\xaa":
        continue
    hits, misses = struct.unpack("<II", ser.read(8))
    total = hits + misses
    rate = 100 * hits / total if total else 0.0
    print(
        f"hits={hits:10d} misses={misses:10d} hit_rate={rate:.4f}"
    )
