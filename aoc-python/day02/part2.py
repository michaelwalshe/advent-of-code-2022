from __future__ import annotations

import argparse
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')

    
def rps(elf, strategy):
    score_map = {
        "A": 1,
        "B": 2,
        "C": 3,
    }
    rps_win = {
        "A": "B",
        "B": "C",
        "C": "A",
    }
    rps_lose = {v: k for k, v in rps_win.items()}

    if strategy == "X":
        score = 0 + score_map[rps_lose[elf]]
    elif strategy == "Y":
        score = 3 + score_map[elf]
    else:
        score = 6 + score_map[rps_win[elf]]

    return score


def compute(s: str) -> int:
    lines = s.splitlines()
    score = 0
    for line in lines:
        print(line)
        score += rps(line[0], line[2])
    return score


INPUT_S = '''\
A Y
B X
C Z
'''
EXPECTED = 12


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
