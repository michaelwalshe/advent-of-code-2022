from __future__ import annotations

import argparse
import os.path

import pytest

import support
from support import Direction4

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


BLIZ_DIRS = {
    ">": Direction4.RIGHT,
    "<": Direction4.LEFT,
    "^": Direction4.UP,
    "v": Direction4.DOWN,
}


def move_blizzards(blizzards, edges):
    minx, maxx, miny, maxy = edges
    new_blizzards = []
    for x, y, d in blizzards:
        nx, ny = d.apply(x, y)
        if nx == minx:
            nx = maxx - 1
        elif nx == maxx:
            nx = minx + 1
        elif ny == miny:
            ny = maxy - 1
        elif ny == maxy:
            ny = miny + 1
        new_blizzards.append((nx, ny, d))
    return new_blizzards


def get_neighbours(me, blizzards, walls, maxy):
    neighbours = []
    blizz_pnts = set((x, y) for x, y, _ in blizzards)
    for p in (me, *support.adjacent_4(*me)):
        if p not in blizz_pnts and p not in walls and p[1] >= 0 and p[1] <= maxy:
            neighbours.append(p)
    return neighbours


def shortest_path(walls, all_blizzards, start, end, edges):
    paths = [[(start, 0)]]
    path_index = 0
    previous_states = {(start, 0)}

    while path_index < len(paths):
        current_path = paths[path_index]
        last_point, t = current_path[-1]
        nt = t + 1
        # next_blizzards = move_bliz    zards(last_blizzards, edges)
        next_points = get_neighbours(last_point, all_blizzards[nt], walls, edges[3])

        if end in next_points:
            current_path.append(end)
            return current_path

        for next_point in next_points:
            if not (next_point, nt) in previous_states:
                new_path = current_path[:]
                new_path.append((next_point, nt))
                paths.append(new_path)
                previous_states.add((next_point, nt))
        path_index += 1

    return []


def compute(s: str) -> int:
    walls = set()
    blizzards = []
    for y, line in enumerate(s.splitlines()):
        for x, c in enumerate(line):
            if c == "#":
                walls.add((x, y))
            if c in (">", "<", "^", "v"):
                blizzards.append((x, y, BLIZ_DIRS[c]))
    blizzards = frozenset(blizzards)

    miny = min(y for _, y in walls)
    minx = min(x for x, _ in walls)
    maxy = max(y for _, y in walls)
    maxx = max(x for x, _ in walls)

    all_blizzards = [blizzards]
    for _ in range(10000):
        all_blizzards.append(
            move_blizzards(
                all_blizzards[-1],
                (minx, maxx, miny, maxy),
            )
        )

    journey_1 = len(
        shortest_path(
            walls,
            all_blizzards,
            (minx + 1, miny),
            (maxx - 1, maxy),
            (minx, maxx, miny, maxy),
        )
    ) - 1

    journey_2 = len(
        shortest_path(
            walls,
            all_blizzards[journey_1:],
            (maxx - 1, maxy),
            (minx + 1, miny),
            (minx, maxx, miny, maxy),
        )
    ) - 1

    journey_3 = len(
        shortest_path(
            walls,
            all_blizzards[(journey_1 + journey_2):],
            (minx + 1, miny),
            (maxx - 1, maxy),
            (minx, maxx, miny, maxy),
        )
    ) - 1

    return journey_1 + journey_2 + journey_3
    # paths = {(minx + 1, miny)}
    # end = (maxx - 1, maxy)
    # for t in range(10000):
    #     blizzards = move_blizzards(blizzards,(minx, maxx, miny, maxy))
    #     next_paths = set()
    #     for p in paths:
    #         for p in get_neighbours(p, blizzards, walls):
    #             next_paths.add(p)

    #     if end in next_paths:
    #         return t + 1

    #     paths = next_paths


INPUT_S = """\
#.######
#>>.<^<#
#.<..<<#
#>v.><>#
#<^v^^>#
######.#
"""
EXPECTED = 1


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
        print(compute(INPUT_S))
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
