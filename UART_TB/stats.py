import serial, struct

ser = serial.Serial("/dev/ttyUSB1", 115200)
while True:
    if ser.read(1) != b"\xaa":
        continue
    hits, misses = struct.unpack("<II", ser.read(8))
    print(
        f"hits={hits:10d} misses={misses:10d} hit_rate={(hits / (hits + misses) * 100 or 1):.4f}"
    )
