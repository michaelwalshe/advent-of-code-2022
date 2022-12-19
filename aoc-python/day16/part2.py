from __future__ import annotations

import argparse
import itertools
import os.path
import re

import pytest

import support

INPUT_TXT = os.path.join(os.path.dirname(__file__), "input.txt")


class Valve:
    def __init__(self, id, rate, tunnels):
        self.id = id
        self.rate = rate
        self.tunnels = tunnels

    def __repr__(self):
        return f"Valve({self.id}, {self.rate}, {self.tunnels})"


def shortest_path(rooms, start, end):
    paths = [[start]]
    path_index = 0
    previous_point_ids = {start}

    while path_index < len(paths):
        current_path = paths[path_index]
        last_point_id = current_path[-1]
        next_points_ids = rooms[last_point_id].tunnels
        if end in next_points_ids:
            current_path.append(end)
            return current_path

        for next_point_id in next_points_ids:
            if next_point_id not in previous_point_ids:
                new_path = current_path[:]
                new_path.append(next_point_id)
                paths.append(new_path)
                previous_point_ids.add(next_point_id)
        path_index += 1

    return []


def compute(s: str) -> int:
    # Get dict of all rooms to info
    rooms = {}
    line_pat = re.compile(
        r"Valve (\w+) has flow rate=(\d+);" r" tunnels? leads? to valves? ([\w,\s]+)"
    )
    tunnel_pat = re.compile(r"([a-zA-Z]+)")
    for line in s.splitlines():
        (valve, rate, tunnels) = re.findall(line_pat, line)[0]
        tunnels = re.findall(tunnel_pat, tunnels)

        rooms[valve] = Valve(valve, int(rate), tunnels)

    # Get shortest path from every node to the others
    path_lengths = {}
    for start, end in itertools.combinations(rooms.keys(), 2):
        # Only calculate for different nodes and for useful end points
        if (start == "AA" or end == "AA") or (
            rooms[start].rate > 0 and rooms[end].rate > 0
        ):
            shortest = shortest_path(rooms, start, end)
            path_lengths[(start, end)] = len(shortest)
            path_lengths[(end, start)] = len(shortest)

    # Calculate the paths from start node to all others, getting ticks used
    # and flow rate given by each. Then move to end node, remove from possible
    # paths, and calculate paths from there to all others etc. Do these for all
    # nodes, only adding paths if they wouldn't go over 26t
    # Use this to calculate all best paths of total t < 26
    interested_rooms = frozenset(id for id, v in rooms.items() if v.rate > 0)
    possible_paths = [("AA", 0, 0, frozenset())]
    paths = {}
    while possible_paths:
        node, flow, tick, used = possible_paths.pop()

        paths[used] = max(paths.get(used, flow), flow)

        for room in interested_rooms - used:
            used_ticks = tick + path_lengths[(node, room)]
            if used_ticks < 26:
                possible_paths.append(
                    (
                        room,
                        flow + (26 - used_ticks) * rooms[room].rate,
                        used_ticks,
                        used | {room},
                    )
                )

    # Get the best combination of 2 paths where no nodes are repeated, 
    max_flow = 0
    for (p1, f1), (p2, f2) in itertools.combinations(paths.items(), 2):
        if p1.intersection(p2) == set() and f1 + f2 > max_flow:
            max_flow = f1 + f2

    return max_flow


INPUT_S = """\
Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II
"""
EXPECTED = 1707


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

    compute(INPUT_S)

    with open(args.data_file) as f, support.timing():
        print(compute(f.read()))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
