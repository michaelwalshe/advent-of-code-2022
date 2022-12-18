using Test

using aocJulia: helpers


function compute(s, check_row=10)
    sensors = []
    beacons = []
    distances = []
    for line in split(chomp(s), "\n")
        (sx, sy, bx, by) = [parse(Int, i.match) for i in eachmatch(r"-?\d+", line)]

        d = abs(sx - bx) + abs(sy - by)

        push!(sensors, (sx, sy))
        push!(beacons, (bx, by))
        push!(distances, d)
    end

    sensors_beacons = Set(union(sensors, beacons))

    min_x = minimum(p -> p[1][1] - p[2], zip(sensors, distances))
    max_x = maximum(p -> p[1][1] + p[2], zip(sensors, distances))
    
    n = 0
    for i in min_x:max_x
        for (sensor, d) in zip(sensors, distances)
            if (
                (abs(sensor[1] - i) + abs(sensor[2] - check_row)) <= d
                && (i, check_row) ∉ sensors_beacons
            )
                n += 1
                break
            end
        end
    end

    return n
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
EXPECTED = 26

@test compute(INPUTS_S, 10) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT, 2000000))