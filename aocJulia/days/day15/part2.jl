using Test

using aocJulia: helpers


mutable struct Sensor
    x
    y
    d
end


function compute(s, max_val=4000000)
    sensors = []
    for line in split(chomp(s), "\n")
        (sx, sy, bx, by) = [parse(Int, i.match) for i in eachmatch(r"-?\d+", line)]

        d = abs(sx - bx) + abs(sy - by)

        push!(sensors, Sensor(sx, sy, d))
    end
 

    for s in sensors
        # Trace the edge of each sensor range
        # checking if this is in another sensors range
        for diff in 0:(s.d - 1)
            minx = s.x - s.d - 1
            maxx = s.x + s.d - 1
            for (edge_x, edge_y) in (
                (minx + diff, s.y - diff),
                (minx + diff, s.y + diff),
                (maxx - diff, s.y + diff),
                (maxx - diff, s.y - diff)
            )
                # Don't go past min/max possible values
                if (
                    edge_x < 0
                    || edge_y < 0
                    || edge_x > max_val
                    || edge_y > max_val
                )
                    continue
                end
                
                possible = true
                for s2 in sensors
                    if (abs(s2.x - edge_x) + abs(s2.y - edge_y)) <= s2.d
                        possible = false
                        break
                    end
                end
                if possible
                    return edge_x * 4000000 + edge_y
                end

            end
        end
    end

end


INPUTS_S = """Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3
"""
EXPECTED = 56000011

@test compute(INPUTS_S, 20) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT, 4000000))