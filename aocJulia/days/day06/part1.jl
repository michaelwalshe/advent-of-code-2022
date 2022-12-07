using Test

using aocJulia: helpers


function compute(s)
    for i in 1:(length(s) - 4)
        char_set = Set(s[i:(i+3)])
        if length(char_set) == 4
            return i+3
        end
    end
end


INPUTS_S = [
    "mjqjpqmgbljsphdztnvjfqwrcgsmlb",
    "bvwbjplbgvbhsrlpgdmjqwftvncz",
    "nppdvjthqldpwncqszvftbrmjlhg",
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg",
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"
]
EXPECTED = [7, 5, 6, 10, 11]

for (i, e) in zip(INPUTS_S, EXPECTED)
    @test compute(i) == e
end


INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))