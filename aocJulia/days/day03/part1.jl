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
    rucksacks = @chain s begin
        chomp()
        split("\n")
        collect.()
        map(x -> (x[1:(length(x) ÷ 2)], x[(length(x) ÷ 2 + 1):end]), _)
        map.(x -> priority.(x), _)
        map(x -> intersect(x[1], x[2]), _)
    end
    return sum(rucksacks)[1]

end


INPUTS_S = """
vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw
"""
EXPECTED = 157

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))