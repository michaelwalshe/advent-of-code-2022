from __future__ import annotations

import argparse
from collections import deque
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def compute(s: str) -> int:
    # Parse out numbers
    numbers = support.parse_numbers_split(s)


    # Copy of numbers for modification
    new = deque((enumerate(numbers)))

    for i, n in enumerate(numbers):
        # Find item to move
        index = new.index((i, n))
        # Move item to front of deque
        new.rotate(-index)
        # Remove
        new.popleft()
        # Rotate by -/+ number 
        new.rotate(-n)
        # Insert item at front
        new.appendleft((i, n))

    # Find 0 index
    for i, (_, n) in enumerate(new):
        if n == 0:
            z_ind = i
            break

    return new[(z_ind + 1000) % len(new)][1] + new[(z_ind + 2000) % len(new)][1] + new[(z_ind + 3000) % len(new)][1]


INPUT_S = '''\
1
2
-3
3
-2
0
4
'''
EXPECTED = 3


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

    print(compute(INPUT_S))

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
