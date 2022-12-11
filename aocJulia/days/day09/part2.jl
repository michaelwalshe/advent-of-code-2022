using Pipe, Test

using aocJulia: helpers


mutable struct Point
    x
    y
end
Base.:+(a::Point, b::Point) = Point(a.x + b.x, a.y + b.y)
Base.:(==)(a::Point, b::Point) = a.x == b.x && a.y == b.y

dis(p::Point) = (p.x, p.y)

function move(p::Point, dirs)
    posn = p
    for dir in dirs
        if dir == 'R'
            posn += Point(1, 0)
        elseif dir == 'L'
            posn += Point(-1, 0)
        elseif dir == 'U'
            posn += Point(0, 1)
        elseif dir == 'D'
            posn += Point(0, -1)
        end
    end
    return posn
end


function pull(head::Point, tail::Point)
    newx = (head.x + tail.x) ÷ 2
    newy = (head.y + tail.y) ÷ 2
    if (
        abs(head.x - tail.x) == 2
        && abs(head.y - tail.y) == 2
    )
        return Point(newx, newy)
    elseif abs(head.x - tail.x) == 2
        return Point(newx, head.y)
    elseif abs(head.y - tail.y) == 2
        return Point(head.x, newy)
    else
        return tail
    end
end


function compute(s, nknots=10)
    visited = Set()
    knots = [Point(0, 0) for _ in 1:nknots]
    for line in split(chomp(s), "\n")
        (d, n) = split(line)
        for _ in 1:parse(Int, n)
            knots[1] = move(knots[1], d)
            for i in 2:nknots
                knots[i] = pull(knots[i-1], knots[i])
            end
            push!(visited, dis(knots[10]))
        end
    end    
    return length(visited)
end


INPUTS_S1 = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""
EXPECTED1 = 1

INPUTS_S = """R 5
U 8
L 8
D 3
R 17
D 10
L 25
U 20
"""
EXPECTED = 36

@test compute(INPUTS_S1) == EXPECTED1
@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))