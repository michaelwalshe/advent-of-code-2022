from __future__ import annotations

import argparse
import os.path
from typing import NamedTuple

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


# NamedTuples are sloooooow so remove
class Point(NamedTuple):
    x: int
    y: int


def compute(s: str) -> int:
    lines = s.splitlines()
    rocks = set()
    for line in lines:
        path = [tuple(map(int, p.split(","))) for p in line.split("->")]

        for i in range(len(path) - 1):
            r1, r2 = path[i : (i + 2)]

            dx = -1 if r2[0] < r1[0] else 1
            dy = -1 if r2[1] < r1[1] else 1

            for x in range(r1[0], r2[0] + dx, dx):
                for y in range(r1[1], r2[1] + dy, dy):
                    rocks.add((x, y))

    nsand = 0
    lowest = max(rocks, key=lambda x: x[1])[1]
    ground = lowest + 2
    while True:
        nsand += 1
        sand = (500, 0)

        while True:
            down = (sand[0], sand[1] + 1)
            dleft = (sand[0] - 1, sand[1] + 1)
            dright = (sand[0] + 1, sand[1] + 1)

            if sand[1] + 1 == ground:
                rocks.add(sand)
                break
            elif down not in rocks:
                sand = down
            elif dleft not in rocks:
                sand = dleft
            elif dright not in rocks:
                sand = dright
            else:
                rocks.add(sand)
                break

        if sand == (500, 0):
            break

    return nsand


INPUT_S = """\
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""
EXPECTED = 93


@pytest.mark.parametrize(
    ("input_s", "expected"),
    ((INPUT_S, EXPECTED),),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("data_file", nargs="?", default=INPUT_TXT)
    args = parser.parse_args()

    print(compute(INPUT_S))

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
