from __future__ import annotations

import argparse
import os.path
from typing import NamedTuple

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


class Point(NamedTuple):
    x: int
    y: int


def compute(s: str) -> int:
    lines = s.splitlines()
    rocks = set()
    for line in lines:
        path = [Point(*map(int, p.split(","))) for p in line.split("->")]

        for i in range(len(path) - 1):
            r1, r2 = path[i : (i + 2)]

            dx = -1 if r2.x < r1.x else 1
            dy = -1 if r2.y < r1.y else 1

            for x in range(r1.x, r2.x + dx, dx):
                for y in range(r1.y, r2.y + dy, dy):
                    rocks.add(Point(x, y))

    nsand = 0
    lowest = max(rocks, key=lambda p: p.x).x
    while True:
        nsand += 1
        sand = Point(500, 0)

        while True:
            down = Point(sand.x, sand.y + 1)
            dleft = Point(sand.x - 1, sand.y + 1)
            dright = Point(sand.x + 1, sand.y + 1)

            if not down in rocks:
                sand = down
            elif not dleft in rocks:
                sand = dleft
            elif not dright in rocks:
                sand = dright
            else:
                rocks.add(sand)
                break

            if sand.y > lowest:
                break
        if sand.y > lowest:
            break

    return nsand - 1


INPUT_S = """\
498,4 -> 498,6 -> 496,6
503,4 -> 502,4 -> 502,9 -> 494,9
"""
EXPECTED = 24


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

    # with open(args.data_file) as f, support.timing():
    #     print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
