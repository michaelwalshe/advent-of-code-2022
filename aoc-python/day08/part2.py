from __future__ import annotations

import argparse
import os.path

import numpy as np
import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


def get_seen(trees, t):
    seen = 0
    for t2 in trees:
        seen += 1
        if t2 >= t:
            break
    return seen


def compute(s: str) -> int:
    lines = s.splitlines()
    nrows = len(lines)
    ncols = len(lines[0])
    trees = np.zeros((nrows, ncols))
    for j, line in enumerate(lines):
        for i, t in enumerate(line):
            trees[j, i] = int(t)
    scores = []
    for j in range(0, ncols):
        for i in range(0, nrows):
            t = trees[j, i]
            up = reversed(trees[:j, i])
            down = trees[(j + 1) :, i]
            left = reversed(trees[j, :i])
            right = trees[j, (i + 1) :]
            score = (
                get_seen(up, t)
                * get_seen(down, t)
                * get_seen(left, t)
                * get_seen(right, t)
            )
            scores.append(score)

    return max(scores)


INPUT_S = """\
30373
25512
65332
33549
35390
"""
EXPECTED = 8


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
