using Test

using aocJulia: helpers


function compute(s)
    games = split.(split(chomp(s), "\n"), " ")
    rps_map = Dict(
        "A" => "R",
        "B" => "P",
        "C" => "S",
        "X" => "R",
        "Y" => "P",
        "Z" => "S"
    )
    score_map = Dict(
        "R" => 1,
        "P" => 2,
        "S" => 3
    )
    win_map = Dict(
        "R" => "P",
        "P" => "S",
        "S" => "R"
    )
    lose_map =  Dict(values(win_map) .=> keys(win_map))

    games = map.(x -> rps_map[x], games)

    score = 0
    for game in games
        if game[1] == game[2]
            score += 3
        elseif game[1] != win_map[game[2]]
            score += 6
        end
        score += score_map[game[2]]
    end

    return score
end


INPUTS_S = """
A Y
B X
C Z
"""
EXPECTED = 15


@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))