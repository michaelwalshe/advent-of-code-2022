using Pipe, Test

using aocJulia: helpers

function get(x, i)
    checkbounds(Bool, x, i) && return x[i]
    return nothing
end

function compare(l::Number, r::Number)
    l < r && return true
    l > r && return false
    return nothing
end


function compare(l::Number,  r::Vector)
    return compare([l], r)
end


function compare(l::Vector,  r::Number)
    return compare(l, [r])
end


function compare(l::Vector, r::Vector)
    for i in 1:max(length(l), length(r))
        ri = get(r, i)
        li = get(l, i)

        if isnothing(ri)
            return false
        elseif isnothing(li)
            return true
        else
            comp = compare(li, ri)
        end

        !isnothing(comp) && return comp
    end
end

function compute(s)
    str_pairs = @pipe s |> chomp |> split(_, "\n\n") |> split.(_, "\n")
    pairs = []
    for (i, (p1, p2)) in enumerate(str_pairs)
        p1 = eval(Meta.parse(p1))
        p2 = eval(Meta.parse(p2))
        
        if compare(p1, p2)
            push!(pairs, i)
        end
    end
    return sum(pairs)
end


INPUTS_S = """[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""
EXPECTED = 13

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))