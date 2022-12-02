from __future__ import annotations

import argparse
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')

def rps_score(elf, me):
    if elf == me:
        return 3
    if elf == "A" and me == "B":
            return 6
    elif elf == "B" and me == "C":
            return 6
    elif elf == "C" and me == "A":
            return 6
    return 0

    
def rps(elf, me):
    score_map = {
        "X": 1,
        "Y": 2,
        "Z": 3,
    }
    rps_me_to_elf = {
        "X": "A",
        "Y": "B",
        "Z": "C",
    }

    return score_map[me] + rps_score(elf, rps_me_to_elf[me])

def compute(s: str) -> int:
    lines = s.splitlines()
    score = 0
    for line in lines:
        score += rps(line[0], line[2])
    return score


INPUT_S = '''\
A Y
B X
C Z
'''
EXPECTED = 15


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
