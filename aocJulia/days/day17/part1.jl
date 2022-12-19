using Test

using aocJulia: helpers


struct Point
    x
    y
end
Point(p) = Point(p[1], p[2])
Base.:+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
Base.:(==)(a::Point, b::Point) = a.x == b.x && a.y == b.y
Base.:isless(a::Point, b::Point) = a.y < b.y

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


function top(chute)
    return maximum(p -> p.y, collect(chute))
end


function move(rock::Rock, dir, chute)
    new = Rock(
        move(rock.corner, dir),
        move.(rock.filled, dir)
    )

    if (
        # Check if this would hit a rock or the sides or the floor
        any(map(p -> p.x <= 0, new.filled))
        || any(map(p -> p.x >= 8, new.filled))
        || any(new.filled .∈ Ref(chute))
        # (
        #     any(map(p -> p.y <= maximum(p -> p.y, chute), new.filled))
        #     && any(new.filled ∈ chute)
        # )
    )
        return rock
    else
        return new
    end
end


function compute(s)
    # Get repeated iterators over instructions and shapes
    jets = s |> chomp |> collect |> Iterators.cycle
    shapes = Iterators.cycle([1, 2, 3, 4, 5])
    (jet, jstate) = iterate(jets)
    (shape, shstate) = iterate(shapes)

    # Initialise chute of rocks with a floor
    chute = Set([Point(x, 0) for x in 1:7])

    # Start 4 above the floor
    start_y = 4
    n = 0
    while n < 1000000000000
        local r, newr
        # Create rock at starting point of specified shape
        r = Rock(Point(3, start_y), shape)

        while true
            # Move rock using jet, always happens
            r = move(r, jet, chute)
            # Try to move down
            newr = move(r, 'v', chute)

            # Get next jet
            jet, jstate = iterate(jets, jstate)
            if r == newr
                break
            else
                r = newr
            end
        end
        # If reached the bottom, push this rocks parts to the chute
        push!(chute, newr.filled...)
        # Set a new max height to start
        start_y = top(chute) + 4
        # Add a rock
        n += 1
        # Iterate to the next shape
        (shape, shstate) = iterate(shapes, shstate)

        # Keep Chute size manageable
        
    end

    return maximum(p -> p.y, collect(chute))
end


INPUTS_S = """>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"""
EXPECTED = 1514285714288

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))
