using Test

using aocJulia: helpers


struct Point
    x
    y
end
Point(p) = Point(p[1], p[2])
Base.:+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
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
    )
        return rock
    else
        return new
    end
end


function get_chute_state(chute)
    top_rocks = []
    for i in 1:7
        push!(top_rocks, maximum(p.y for p in chute if p.x == i))
    end

    miny = minimum(top_rocks)

    floor_shape = [Point(p.x, p.y - miny) for p in chute if p.y >= miny]

    return sort(floor_shape, by= p -> p.x)
end


function compute(s)
    # Get repeated iterators over instructions and shapes
    jets = s |> chomp |> collect |> Iterators.cycle
    shapes = Iterators.cycle([1, 2, 3, 4, 5])
    (jet, jet_state) = iterate(jets)
    (shape, shape_state) = iterate(shapes)

    # Initialise chute of rocks with a floor
    chute = Set([Point(x, 0) for x in 1:7])

    # Start 4 above the floor
    start_y = 4
    n = 0
    max_height = 0
    done_at = nothing
    done_at_val = nothing
    done_at_delta_height = nothing
    chute_states = Dict()
    while n < 2022 # 1_000_000_000_000
        local r, newr
        # Create rock at starting point of specified shape
        r = Rock(Point(3, start_y), shape)

        chute_state = (get_chute_state(chute), shape_state, jet_state)

        if chute_state in keys(chute_states)
            println("Here!")
            (oldn, oldheight) = chute_states[chute_state]
            period = n - oldn
            # remaining = 1_000_000_000_000 - oldn
            remaining = 2022 - oldn
            loops = remaining ÷ period

            n = remaining ÷ period
            done_at = n + remaining % period
            done_at_val = oldheight + loops * (max_height - oldheight)
            done_at_delta_height = max_height
        else
            chute_states[chute_state] = (n, max_height)
        end


        if !isnothing(done_at) && n == done_at
            return done_at_val + (max_height - done_at_delta_height)
        end

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
        push!(chute, newr.filled...)
        # Set a new max height to start
        max_height = top(chute)
        start_y = max_height + 4
        # Add a rock
        n += 1
        # Iterate to the next shape
        (shape, shape_state) = iterate(shapes, shape_state)
    end

    return maximum(p -> p.y, collect(chute))
end


INPUTS_S = """>>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>
"""
EXPECTED = 1514285714288

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))
