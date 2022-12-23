from __future__ import annotations

import argparse
import os.path
import re

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


# Are these all correct? Work for example
def cube_map_sample(chunk_size):
    """
            1111    
            1111    
            1111    
            1111    
    222233334444    
    222233334444    
    222233334444    
    222233334444    
            55556666
            55556666
            55556666
            55556666
    """
    cube = dict()
    for y in range(0, chunk_size):
        # 1 left side to 3 top side
        cube[(2 * chunk_size - 1, y, 2)] = (chunk_size + y, chunk_size, 1)
        # 1 right side to 6 right side
        cube[(3 * chunk_size, y, 0)] = (4 * chunk_size - 1, 3 * chunk_size - y - 1, 2)
    for y in range(chunk_size, 2 * chunk_size):
        # 2 left side to 6 bottom side
        cube[(-1, y, 2)] = (5 * chunk_size - y - 1, 3 * chunk_size - 1, 3)
        # 4 right side to 6 top side
        cube[(3 * chunk_size, y, 0)] = (5 * chunk_size - 1 - y, 2 * chunk_size,1)
    for y in range(2 * chunk_size, 3 * chunk_size):
        # 5 left side to 3 bottom side
        cube[(2 * chunk_size - 1, y, 2)] = (4 * chunk_size - y - 1, 2 * chunk_size - 1, 3)
        # 6 right side to 1 right side
        cube[(4 * chunk_size, y, 0)] = (3 * chunk_size - 1, 3 * chunk_size - y, 2)
    for x in range(0, chunk_size):
        # 2 top side to 1 top side
        cube[(x, chunk_size - 1, 3)] = (2 * chunk_size + x, 0, 1)
        # 2 bottom side to 5 bottom side
        cube[(x, 2 * chunk_size, 3)] = (3 * chunk_size - x - 1, 3 * chunk_size - 1, 1)
    for x in range(chunk_size, 2 * chunk_size):
        # 3 top side to 1 left side
        cube[(x, chunk_size - 1, 3)] = (2 * chunk_size, x - chunk_size, 0)
        # 3 bottom side to 5 left side
        cube[(x, 2 * chunk_size, 1)] = (2 * chunk_size, 4 * chunk_size - x - 1, 0)
    for x in range(2 * chunk_size, 3 * chunk_size):
        # 1 top side to 2 top side
        cube[(x, -1, 3)] = (3 * chunk_size - x, chunk_size, 1)
        # 5 bottom side to 2 bottom side
        cube[(x, 3 * chunk_size, 1)] = (3 * chunk_size - x -1, 2 * chunk_size - 1, 3)
    for x in range(3 * chunk_size, 4 * chunk_size):
        # 6 top side to 4 elft side
        cube[(x, 2 * chunk_size - 1, 3)] = (3 * chunk_size - 1, 5 * chunk_size - x - 1, 2)
        # 6 bottom side to 2 right side
        cube[(x, 3 * chunk_size, 1)] = (0, 5 * chunk_size - x - 1, 0)
    return cube



def cube_map(chunk_size):
    """
        11112222
        11112222
        11112222
        11112222
        3333    
        3333    
        3333    
        3333    
    44445555
    44445555
    44445555
    44445555
    6666
    6666
    6666
    6666
    """
    cube = dict()
    for y in range(0, chunk_size):
        # 1 left side to 4 left side
        cube[(chunk_size - 1, y, 2)] = (0, 3 * chunk_size - y - 1, 0)
        # 2 right side to 5 right side
        cube[(3 * chunk_size, y, 0)] = (2 * chunk_size - 1, 3 * chunk_size - y - 1, 2)
    for y in range(chunk_size, 2 * chunk_size):
        # 3 left side to 4 top side
        cube[(chunk_size - 1, y, 2)] = (y - chunk_size, 2 * chunk_size, 1)
        # 3 right side to 2 bottom side
        cube[( 2 * chunk_size, y, 0)] = ( y + chunk_size, chunk_size - 1, 3)
    for y in range(2 * chunk_size, 3 * chunk_size):
        # 4 left side to 1 left side
        cube[(-1, y, 2)] = (chunk_size, 3 * chunk_size - y - 1, 0)
        # 5 right side to 2 right side
        cube[(2 * chunk_size, y, 0)] = (3 * chunk_size - 1, 3 * chunk_size - y - 1, 2)
    for y in range(3 * chunk_size, 4 * chunk_size):
        # 6 left side to 1 top side
        cube[(-1, y, 2)] = (y - (2 * chunk_size), 0, 1)
        # 6 right side to 5 bottom side
        cube[(chunk_size, y, 0)] = (y - (2 * chunk_size), 3 * chunk_size - 1, 3)
    for x in range(0, chunk_size):
        # 4 top side to 3 left side
        cube[(x, 2 * chunk_size - 1,  3)] = (chunk_size, x + chunk_size,  0)
        # 6 bottom side to 2 top side
        cube[(x, 4 * chunk_size, 1)] = (x + 2 * chunk_size, 0, 1)
    for x in range(chunk_size, 2 * chunk_size):
        # 1 top side to 6 left side
        cube[(x, -1, 3)] = (0, x + 2 * chunk_size, 0)
        # 5 bottom side to 6 right side
        cube[(x, 3 * chunk_size, 1)] = (chunk_size - 1, x + 2 * chunk_size, 2)
    for x in range(2 * chunk_size, 3 * chunk_size):
        # 2 top side to 6 bottom side
        cube[(x, -1, 3)] = (x - 2 * chunk_size, 4 * chunk_size - 1, 3)
        # 2 bottom side to 3 left side
        cube[(x, chunk_size, 1)] = (2 * chunk_size - 1, x - chunk_size, 2)
    return cube


def move(x, y, d, cube):
    if d == 0:
        dp = (1, 0)
    elif d == 1:
        dp = (0, 1)
    elif d == 2:
        dp = (-1, 0)
    elif d == 3:
        dp = (0, -1)

    nx = x + dp[0]
    ny = y + dp[1]

    (nx, ny, d) = cube.get((nx, ny, d), (nx, ny, d))

    return ((nx, ny), d)


def rotate(d, side):
    if side == "R":
        return (d + 1) % 4
    elif side == "L":
        return (d - 1) % 4


def compute(s: str, sample: bool = True) -> int:
    # Parse input, create coords dictionary
    grid_s, instructions = s.split("\n\n")
    coords = {}
    lines = grid_s.splitlines()
    for y, line in enumerate(lines):
        for x, c in enumerate(line):
            if c in (".", "#"):
                coords[(x, y)] = c
    
    # Get starting position
    free = [k for k, v in coords.items() if v == "."]
    starty = min(y for _, y in free)
    startx = min(x for x, y in free if y == starty)

    # Create cube portals, that will move you if entered and fix direction
    cube = cube_map(50) if not sample else cube_map_sample(4)

    current = (startx, starty)
    dir = 0
    for instr in re.findall(r"\d+|\w", instructions):
        if instr.isnumeric():
            for _ in range(int(instr)):
                new, newdir = move(*current, dir, cube)
                if coords.get(new, "#") == "#":
                    break
                dir = newdir
                current = new
        else:
            dir = rotate(dir, instr)

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
EXPECTED = 5031


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
        print(compute(f.read(), sample=False))

    return 0


if __name__ == '__main__':
    raise SystemExit(main())
