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
    if head == tail
        return tail
    end

    for dirs in (
        "RR",
        "LL",
        "UU",
        "DD",
        "URU",
        "DRD",
        "ULU",
        "DLD",
        "ULL",
        "DLL",
        "URR",
        "DRR"
    )
        if move(tail, dirs) == head
            return move(tail, dirs[1:(end-1)])
        end
    end

    for dirs in ('R', 'L', 'U', 'D', "UR", "DR", "UL", "DL")
        if move(tail, dirs) == head
            return tail
        end
    end
    
    error("Oops $head $tail")
end


function compute(s)
    visited = Set()
    head = Point(0, 0)
    tail = head
    for line in split(chomp(s), "\n")
        (d, n) = split(line)
        for _ in 1:parse(Int, n)
            head = move(head, d)
            tail = pull(head, tail)
            push!(visited, dis(tail))
        end
    end    
    return length(visited)
end


INPUTS_S = """R 4
U 4
L 3
D 1
R 4
D 1
L 5
R 2
"""
EXPECTED = 13

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))