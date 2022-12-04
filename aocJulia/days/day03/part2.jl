using Chain, Test

using aocJulia: helpers


function priority(c)
    if isuppercase(c)
        return Int(c) - 38
    else
        return Int(c) - 96
    end
end

function compute(s)
    sacks = s |> chomp |> split .|> collect
    sacks = map.(x -> priority(x), sacks)
    badges = []
    for i in 1:3:length(sacks)
        push!(badges, intersect(sacks[i], sacks[i+1], sacks[i+2]))
    end
    return sum(badges)[1]
end


INPUTS_S = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
EXPECTED = 70

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))