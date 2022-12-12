from __future__ import annotations

import argparse
import os.path

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), 'input.txt')


def get_neighbours(point, hill):
    neighbours = []
    v = hill[point]
    for i, j in support.adjacent_4(point[0], point[1]):
        if hill.get((i, j), 9999) <= v + 1:
            neighbours.append((i, j))
    return neighbours


def shortest_path(graph, start, end):
    paths = [[start]]
    path_index = 0
    previous_points = {start}

    while path_index < len(paths):
        current_path = paths[path_index]
        last_point = current_path[-1]
        next_points = get_neighbours(last_point, graph)
        if end in next_points:
            current_path.append(end)
            return current_path

        for next_point in next_points:
            if not next_point in previous_points:
                new_path = current_path[:]
                new_path.append(next_point)
                paths.append(new_path)
                previous_points.add(next_point)
        path_index += 1

    return []


def compute(s: str) -> int:
    lines = s.splitlines()
    hill = {}
    for j, line in enumerate(lines):
        for i, c in enumerate(line):
            if c == "S":
                start = (i, j)
                hill[(i, j)] = 1
            elif c == "E":
                end = (i, j)
                hill[(i, j)] = 26
            else:
                hill[(i, j)] = ord(c) - 96

    return len(shortest_path(hill, start, end)) - 1



INPUT_S = '''\
Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi
'''
EXPECTED = 29


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
