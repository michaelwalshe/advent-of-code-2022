using DataStructures, Test

using aocJulia: helpers


struct Point
    x
    y
end
Point(p) = Point(p[1], p[2])
Base.:+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
Base.:(==)(a::Point, b::Point) = a.x == b.x && a.y == b.y


function find_elf(p , coords, dir)
    found = false
    # Check north/south
    if dir in (Point(0, -1) , Point(0, 1))
        # DE, D, DW
        for dp in Point.([(1, 0), (0, 0), (-1, 0)]) .+ Ref(dir)
            if p + dp in coords
                found = true
                break
            end
        end
    # Check east/west
    elseif dir in (Point(1, 0), Point(-1, 0))
        # D, SD, ND
        for dp in Point.([(0, 0), (0, -1), (0, 1)]) .+ Ref(dir)
            if p + dp in coords
                found = true
                break
            end
        end
    end

    return found
end


function compute(s)
    # Get initial positions of all elves
    elves = []
    for (y, line) in split(s, "\n") |> enumerate
        for (x, c) in line |> enumerate
            if c == '#'
                push!(elves, Point(x, y))
            end
        end
    end

    # Inital order of directions to consider: north, south, west, east
    directions = Point.([(0, -1), (0, 1), (-1, 0), (1, 0)])
    # TO use for finding adjacent 8 points to check for elves
    adjacent_8 = []
    for y_d in (-1, 0, 1)
        for x_d in (-1, 0, 1)
            if y_d == x_d == 0
                continue
            end
            push!(adjacent_8, Point(x_d, y_d))
        end
    end

    # Rounds of movement
    for _ in 1:10
        elves_set = Set(elves)
        moves = []
        # Check movement for each elf
        for elf in elves
            # If  no elves in adjacent 8, skip
            skip = true
            for dir in adjacent_8
                if elf + dir in elves_set
                    skip = false
                    break
                end
            end
            if skip
                push!(moves, elf)
                continue
            end

            # If we haven't skipped, then check which direction to move in
            did_not_break = true
            for dir in directions
                # Can it move in this direction?
                if !find_elf(elf, elves_set, dir)
                    # If so, set break condition and add move
                    did_not_break = false
                    push!(moves, elf + dir)
                    break
                end
            end
            if did_not_break
                # If couldnt move, just add existing position
                push!(moves, elf)
            end
        end

        # Check number of elves proposing a new position
        moves_counts = counter(moves)
        for (i, move) in enumerate(moves)
            # If more than 1 proposed, ignore
            if moves_counts[move] == 1
                elves[i] = move
            end
        end

        # Rotate directions by 1
        directions = [directions[2:end]; directions[1]]
    end


    minx = minimum([p.x for p in elves])
    maxx = maximum([p.x for p in elves])
    miny = minimum([p.y for p in elves])
    maxy = maximum([p.y for p in elves])

    free = 0
    elves_set = Set(elves)
    for x in minx:maxx
        for y in miny:maxy
            if Point(x, y) ∉ elves_set
                free += 1
            end
        end
    end

    return free
end


INPUTS_S = """....#..
..###.#
#...#.#
.#...##
#.###..
##.#.##
.#..#..
"""
EXPECTED = 110

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))