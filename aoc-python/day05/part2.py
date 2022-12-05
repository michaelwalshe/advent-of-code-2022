from __future__ import annotations

import argparse
import os.path
import re
from collections import deque

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


def extract_crates(crates):
    crates = crates.splitlines()
    n_stacks = 1 + len(crates[0]) // 4
    stacks = [deque() for _ in range(n_stacks)]
    for line in crates[:-1]:
        stack = 0
        for i in range(1, len(line), 4):
            c = line[i]
            if c.isalpha():
                stacks[stack].append(c)
            stack += 1
    return stacks


def compute(s: str) -> int:
    crates, moves = s.split("\n\n")
    stacks = extract_crates(crates)

    moves_pat = re.compile(r"(\d+)")
    for move in moves.splitlines():
        n, from_stack, to_stack = [int(e) for e in moves_pat.findall(move)]
        s = deque()
        for _ in range(n):
            c = stacks[from_stack - 1].popleft()
            s.appendleft(c)
        stacks[to_stack - 1].extendleft(s)
    return "".join(s[0] for s in stacks)


INPUT_S = """\
    [D]    
[N] [C]    
[Z] [M] [P]
 1   2   3 

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2
"""
EXPECTED = "MCD"


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

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
