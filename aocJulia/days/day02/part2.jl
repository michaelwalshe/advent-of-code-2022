using Test

using aocJulia: helpers


function compute(s)
    games = split.(split(chomp(s), "\n"), " ")
    score_map = Dict(
        "A" => 1,
        "B" => 2,
        "C" => 3
    )
    win_map = Dict(
        "A" => "B",
        "B" => "C",
        "C" => "A"
    )
    lose_map =  Dict(values(win_map) .=> keys(win_map))

    score = 0
    for (elf, strategy) in games
        if strategy == "Z"
            score += 6 + score_map[win_map[elf]]
        elseif strategy == "X"
            score += score_map[lose_map[elf]]
        else
            score += 3 + score_map[elf]
        end
    end

    return score
end


INPUTS_S = """
A Y
B X
C Z
"""
EXPECTED = 12


@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))