from __future__ import annotations

import argparse
import os.path

import numpy as np
import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


def compute(s: str) -> int:
    lines = s.splitlines()
    nrows = len(lines)
    ncols = len(lines[0])
    trees = np.zeros((nrows, ncols))
    for j, line in enumerate(lines):
        for i, t in enumerate(line):
            trees[j, i] = int(t)

    visible = 2 * nrows + (ncols - 2) * 2
    for j in range(1, ncols-1):
        for i in range(1, nrows-1):
            t = trees[j, i]
            up = trees[:j, i].max()
            down = trees[j:, i].max()
            left = trees[j, :i].max()
            right = trees[j, i:].max()
            if any((up < t, down < t, left < t, right < t)):
                visible += 1

    return visible


INPUT_S = """\
30373
25512
65332
33549
35390
"""
EXPECTED = 21


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

    print(compute(INPUT_S ))
    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
