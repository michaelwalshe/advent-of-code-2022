using Test

using aocJulia: helpers


struct Point
    x
    y
end
Point(p) = Point(p[1], p[2])
Base.:+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
Base.:-(a::Point, b::Point) = Point(a.x - b.x, a.y - b.y)
Base.:(==)(a::Point, b::Point) = a.x == b.x && a.y == b.y


function move(p::Point, dir)
    posn = p
    if dir == '>'
        posn += Point(1, 0)
    elseif dir == '<'
        posn += Point(-1, 0)
    elseif dir == '^'
        posn += Point(0, 1)
    elseif dir == 'v'
        posn += Point(0, -1)
    end
    return posn
end


struct Rock
    corner::Point
    filled::Vector
    function Rock(corner::Point, shape::Number)
        if shape == 1
            parts = [(0, 0), (1, 0), (2, 0), (3, 0)]
        elseif shape == 2
            parts = [(0, 1), (1, 0), (1, 1), (1, 2), (2, 1)]
        elseif shape == 3
            parts = [(0, 0), (1, 0), (2, 0), (2, 1), (2, 2)]
        elseif shape == 4
            parts = [(0, 0), (0, 1), (0, 2), (0, 3)]
        elseif shape == 5
            parts = [(0, 0), (0, 1), (1, 0), (1, 1)]
        end

        return new(corner, [corner] .+ Point.(parts))
    end
    function Rock(corner::Point, filled::Vector)
        new(corner, filled)
    end
end
Base.:(==)(a::Rock, b::Rock) = a.corner == b.corner


function move(rock::Rock, dir, chute)
    new = Rock(
        move(rock.corner, dir),
        move.(rock.filled, dir)
    )

    if (
        # Check if this would hit a rock or the sides or the floor
        any(map(p -> p.x <= 0, new.filled))
        || any(map(p -> p.x >= 8, new.filled))
        || in_chute(new, chute)
    )
        return rock
    else
        return new
    end
end


function in_chute(point::Point, chute)
    !(point.y > length(chute)) && chute[point.y][point.x] == 1
end


function in_chute(rock::Rock, chute)
    return any(in_chute.(rock.filled, Ref(chute)))
end


function add_rock(chute, rock)
    max_y = length(chute)
    # For sections that will nestle into the chute, set to 1
    for p in filter(p -> p.y <= max_y, rock.filled)
        chute[p.y][p.x] = 1
    end

    # Find sections outside, resize y to count from 1
    outside = [
        p - Point(0, max_y)
        for p in filter(p -> p.y > max_y, rock.filled)
    ]
    # Convert points to vector of vecs
    # rock_mat = zeros(Int8, 7, maximum([p.y for p in outside]),)
    if length(outside) > 0
        rock_mat = [
            [Int8(0) for _ in 1:7]
            for _ in 1:maximum([p.y for p in outside])
        ]
        for p in outside
            rock_mat[p.y][p.x] = 1
        end
        append!(chute, rock_mat)
    end

    return chute
end


function compute(s, maxn=1000000000000)
    # Get repeated iterators over instructions and shapes
    jets = s |> chomp |> collect |> Iterators.cycle
    shapes = Iterators.cycle([1, 2, 3, 4, 5])
    (jet, jet_state) = iterate(jets)
    (shape, shape_state) = iterate(shapes)

    # Initialise chute of rocks with a floor
    # chute = Set([Point(x, 0) for x in 1:7])
    chute = Vector{Vector{Int8}}([[1, 1, 1, 1, 1, 1, 1]])

    # Start 4 above the floor
    start_y = 5
    max_y = 0
    n = 0
    while n < maxn
        local r, newr
        # Create rock at starting point of specified shape
        r = Rock(Point(3, start_y), shape)

        while true
            # Move rock using jet, always happens
            r = move(r, jet, chute)
            # Try to move down
            newr = move(r, 'v', chute)

            # Get next jet
            jet, jet_state = iterate(jets, jet_state)
            if r == newr
                break
            else
                r = newr
            end
        end
        # If reached the bottom, push this rocks parts to the chute
        chute = add_rock(chute, newr)
        # push!(chute, newr.filled...)

        # keep chute size manageable
        # grab last 6 rows
        # latest = chute[:, max(1, size(chute, 2) - 5):end]
        latest = chute[max(1, length(chute) - 5):end]
        if all(sum(latest) .!= 0)
            # There are no paths all the way through
            max_y += length(chute) - 6
            chute = latest
        end


        # Set a new max height to start
        # start_y = size(chute, 2) + 4
        start_y = length(chute) + 4
        # Add a rock
        n += 1
        # Iterate to the next shape
        (shape, shape_state) = iterate(shapes, shape_state)
    end

    # return chute
    return max_y + length(chute) + 4
end


INPUTS_S = """>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"""
EXPECTED = 1514285714288

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))
