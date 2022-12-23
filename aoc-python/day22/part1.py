from __future__ import annotations

import argparse
import os.path
import re

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def move(x, y, d, grid):
    if d == 0:
        dp = (1, 0)
    elif d == 1:
        dp = (0, 1)
    elif d == 2:
        dp = (-1, 0)
    elif d == 3:
        dp = (0, -1)

    nx = (x + dp[0]) % len(grid[0])
    ny = (y + dp[1]) % len(grid)
    
    while grid[ny][nx] == "":
        nx = (nx + dp[0]) % len(grid[0])
        ny = (ny + dp[1]) % len(grid)

    return (nx, ny)


def rotate(d, side):
    if side == "R":
        return (d + 1) % 4
    elif side == "L":
        return (d - 1) % 4


def compute(s: str) -> int:
    grid_s, instructions = s.split("\n\n")
    coords = {}
    grid_partial = []
    lines = grid_s.splitlines()
    for y, line in enumerate(lines):
        row = []
        for x, c in enumerate(line):
            if c in (".", "#"):
                coords[(x, y)] = c
                row.append(c)
            else:
                row.append("")
        grid_partial.append(row)
    
    # Pad grid to allow for missing spaces in input.txt
    maxx = max(len(row) for row in grid_partial)
    grid = []
    for row in grid_partial:
        if len(row) < maxx:
            row += [""] * (maxx - len(row))
        grid.append(row)

    free = [k for k, v in coords.items() if v == "."]
    starty = min(free, key=lambda p: p[0])[0]
    startx = min(x for x, y in free if y == starty)

    current = (startx, starty)
    dir = 0
    for instr in re.findall(r"\d+|\w", instructions):
        if instr.isnumeric():
            for _ in range(int(instr)):
                new = move(*current, dir, grid)
                if coords.get(new, "#") == "#":
                    break
                current = new
        else:
            dir = rotate(dir, instr)
        # print(format_coords_hash(coords, current))
        # print()

    return 1000 * (current[1] + 1) + 4 * (current[0] + 1) + dir




INPUT_S = '''\
        ...#
        .#..
        #...
        ....
...#.......#
........#...
..#....#....
..........#.
        ...#....
        .....#..
        .#......
        ......#.

10R5L5R10L4R5L5
'''

EXPECTED = 6032


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

    # print(compute(INPUT_S))

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
