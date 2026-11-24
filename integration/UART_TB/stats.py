"""Read canonical cache telemetry: 0xAA followed by 19 little-endian uint32s.

Usage: python3 stats.py --port /dev/ttyUSB1 --csv results.csv
The eight summary counters are followed by all eleven canonical cache states.
"""

import argparse, struct, time, csv, os

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
    "sWritebackReq",
    "sWritebackSend",
    "sWritebackWait",
    "sWriteThroughReq",
    "sWriteThroughSend",
    "sWriteThroughWait",
    "sRefillReq",
    "sRefillWait",
    "sRespond",
]
STATES = FIELDS[8:]
FMT = "<" + "I" * len(FIELDS)
SIZE = struct.calcsize(FMT)
DERIVED = ["acc", "hit_rate", "tc", "tm", "amat", "busy_frac"]

def decode(raw):
    return dict(zip(FIELDS, struct.unpack(FMT, raw)))


def main():
    import serial

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
            v = decode(raw)
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


if __name__ == "__main__":
    main()
