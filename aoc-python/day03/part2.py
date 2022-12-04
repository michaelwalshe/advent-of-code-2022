from __future__ import annotations

import argparse
import os.path

import numpy as np
import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def prioritise(c: str) -> int:
    if c.islower():
        return ord(c) - 96
    else:
        return ord(c) - 38


def compute(s: str) -> int:
    lines = s.splitlines()
    in_common = []
    for i in range(0, len(lines), 3):
        elfs = (lines[i], lines[i+1], lines[i+2])
        a, b, c = (set(map(prioritise, e)) for e in elfs)
        in_common.append(a & b & c)
    
    return sum(map(sum, in_common))


INPUT_S = '''\
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
'''
EXPECTED = 157


@pytest.mark.parametrize(
    ('input_s', 'expected'),
    (
        (INPUT_S, EXPECTED),
    ),
)
def test(input_s: str, expected: int) -> None:
    assert compute(input_s) == expected


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument('data_file', nargs='?', default=INPUT_TXT)
    args = parser.parse_args()

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
