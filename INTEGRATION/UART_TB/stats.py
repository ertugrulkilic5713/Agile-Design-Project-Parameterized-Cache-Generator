"""
Read the 15-word stats frame from the FPGA and print hit rate, AMAT and FSM cycle breakdown.
Usage: python3 stats.py [/dev/ttyUSB1] [log.csv]
"""

# Every time unit, the FPGA sends one frame of 61 bytes.
# byte 0 = 0xAA // start marker.
# byte 1-4 = hits // 32 bit, little endian, low byte first.
# byte 5-8 = misses
# byte 9-12 = writebacks_wb
# byte 13-16 = writes_wt
# byte 17-20 = stores
# byte 21-24 = hitCycles
# byte 25-28 = misCycles
# byte 29-32 = cycles
# byte 33-60 = 7 state-cycle counters: sIdle - sCompare - sWritebacks_wb, sRefillReq, sRefillWait, sWriteThrough_wt, sRespond.
#
#
# acc: accesses: hits + misses in the frame. Every lw/sw that went to the cache (stores to the LED device dont count they bypass the cache).
# tc: average cycles the CPU waited for a request that hit, counted from the cycle the request appears on the bus to the cycle the ack comes back.
# tm: average cycles the CPU waited for a request that missed. It is a full round trip: tag check, (wb of a dirty victim if any in worst-case), refill of whole line from MM beat by beat, respond.
# busy_frac: fraction of all clock cycles in which the cache FSM was not idle. A.k.a. how much procent of the cycles does the cache work/useful.

import argparse, serial, struct, time, csv, os

FIELDS = [
    "hits",
    "misses",
    "writebacks_wb",
    "writes_wt",
    "stores",
    "hitCycles",
    "missCycles",
    "cycles",
    "sIdle",
    "sCompare",
    "sWriteback_wb",
    "sRefillReq",
    "sRefillWait",
    "sWriteThrough_wt",
    "sRespond",
]
STATES = FIELDS[8:]
FMT = "<" + "I" * len(FIELDS)
SIZE = struct.calcsize(FMT)
DERIVED = ["acc", "hit_rate", "tc", "tm", "amat", "busy_frac"]

ap = argparse.ArgumentParser()
ap.add_argument("--port", default="/dev/ttyUSB1")
ap.add_argument("--csv", help="log file; one row per frame")
ap.add_argument(
    "--seconds",
    type=float,
    default=0,
    help="stop after this many seconds (0 = run forever)",
)
ap.add_argument(
    "--tag",
    default="",
    help="free text stored in every CSV row, e.g. the configuration",
)
args = ap.parse_args()

writer = None
if args.csv:
    os.makedirs(os.path.dirname(args.csv) or ".", exist_ok=True)
    f = open(args.csv, "w", newline="")
    writer = csv.writer(f)
    writer.writerow(
        ["t", "tag"]
        + [f"d_{k}" for k in FIELDS]
        + DERIVED
        + [f"tot_{k}" for k in FIELDS]
    )

ser = serial.Serial(args.port, 115200, timeout=2)
t0 = time.time()
prev = None
frames = 0
try:
    while not args.seconds or time.time() - t0 < args.seconds:
        if ser.read(1) != b"\xaa":
            continue
        raw = ser.read(SIZE)
        if len(raw) != SIZE:
            continue
        v = dict(zip(FIELDS, struct.unpack(FMT, raw)))
        if prev is None:
            prev = v
            continue
        d = {k: (v[k] - prev[k]) & 0xFFFFFFFF for k in FIELDS}
        prev = v
        frames += 1

        acc = d["hits"] + d["misses"]
        h = d["hits"] / acc if acc else 0.0
        tc = d["hitCycles"] / d["hits"] if d["hits"] else 0.0
        tm = d["missCycles"] / d["misses"] if d["misses"] else 0.0
        amat = h * tc + (1 - h) * tm
        busy = sum(d[s] for s in STATES if s != "sIdle")
        busy_frac = busy / d["cycles"] if d["cycles"] else 0.0

        print(
            f"acc/frame={acc:>9,d}  hit={h:7.3%}  tc={tc:5.2f}  tm={tm:7.2f}  AMAT={amat:6.2f} cyc"
            f"  | stores={d['stores']:>8,d} wb={d['writebacks_wb']:>7,d} wt={d['writes_wt']:>8,d}"
            f"  | total acc={v['hits'] + v['misses']:,d}"
        )
        if busy:
            print(
                "      "
                + "  ".join(
                    f"{s[1:]}={100 * d[s] / busy:5.1f}%" for s in STATES if s != "sIdle"
                )
                + f"   (busy {100 * busy_frac:.1f}% of frame)"
            )
        if writer:
            writer.writerow(
                [f"{time.time() - t0:.2f}", args.tag]
                + [d[k] for k in FIELDS]
                + [
                    acc,
                    f"{h:.6f}",
                    f"{tc:.4f}",
                    f"{tm:.4f}",
                    f"{amat:.4f}",
                    f"{busy_frac:.5f}",
                ]
                + [v[k] for k in FIELDS]
            )
except KeyboardInterrupt:
    pass
finally:
    if writer:
        f.close()
        print(f"\nlogged {frames} frames to {args.csv}")
