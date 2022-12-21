from __future__ import annotations

import argparse
from collections import Counter
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def adjacent_cubes(p):
    for dp in (
        (1, 0, 0),
        (-1, 0, 0),
        (0, 1, 0),
        (0, -1, 0),
        (0, 0, 1),
        (0, 0, -1),
    ):
        yield (p[0] + dp[0], p[1] + dp[1], p[2] + dp[2])


def compute(s: str) -> int:
    # Get set of all lava cubes
    coords = set()
    for line in s.splitlines():
        x, y, z = [int(n) for n in line.split(",")]
        coords.add((x, y, z))

    # Get list of all air cubes next to lava
    # Will have repeats, each repeat indicates multiple cubes touching
    # the air cube
    air = []
    for p in coords:
        for newp in adjacent_cubes(p):
            if newp not in coords:
                air.append(newp)
    # Get counts of cubes touching air. Sum of values equals total surface area
    air = Counter(air)

    # Initialise list of air pockets
    pockets = []
    # Unique air cubes
    air_points = set(air.keys())
    while air_points:
        # Search for all air touching this air
        a = air_points.pop()
        pocket = {a}
        to_visit = [a]
        while to_visit:
            next_cube = to_visit.pop()
            for c in adjacent_cubes(next_cube):
                # CHeck if new air cube next to this, if so add to pocket
                # and add to list to search
                if c in air_points and c not in pocket:
                    pocket.add(c)
                    to_visit.append(c)
                elif c not in coords:
                    # Additional check for diagonal air cubes not separated by
                    # lava
                    for c2 in adjacent_cubes(c):
                        if c2 in air and c2 not in pocket:
                            pocket.add(c2)
                            to_visit.append(c2)
        # Remove air in the pocket from total set of air
        air_points = air_points - pocket
        # Add Counter for this pocket
        pockets.append({k: v for k, v in air.items() if k in pocket})

    # Largest pocket is exterior? Probably
    largest_pocket = max(pockets, key = lambda d: len(d))
    return sum(v for _, v in largest_pocket.items())


INPUT_S = '''\
2,2,2
1,2,2
3,2,2
2,1,2
2,3,2
2,2,1
2,2,3
2,2,4
2,2,6
1,2,5
3,2,5
2,1,5
2,3,5
'''
EXPECTED = 58


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
