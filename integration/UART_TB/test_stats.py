import re
import struct
import unittest
from pathlib import Path

import stats


class StatsTest(unittest.TestCase):
    def test_frame_matches_canonical_controller(self):
        model = (Path(__file__).resolve().parents[2]
                 / "cache-generator/src/main/scala/model.scala").read_text()
        enum = model.split("object CacheState extends ChiselEnum", 1)[1]
        states = re.findall(r"\bs[A-Z]\w+", enum)
        self.assertEqual(stats.STATES, states)
        self.assertEqual(stats.SIZE, 76)  # 77 bytes including 0xAA.
        values = [0x12345678 + i for i in range(len(stats.FIELDS))]
        frame = struct.pack("<19I", *values)
        decoded = stats.decode(frame)
        self.assertEqual(decoded["hits"], 0x12345678)
        self.assertEqual(decoded["sRespond"], values[-1])
        with self.assertRaises(struct.error):
            stats.decode(frame[:-4])


if __name__ == "__main__":
    unittest.main()
