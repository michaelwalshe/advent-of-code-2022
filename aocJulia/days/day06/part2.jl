using Test

using aocJulia: helpers


function compute(s)
    for i in 1:(length(s) - 14)
        char_set = Set(s[i:(i+13)])
        if length(char_set) == 14
            return i+13
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
EXPECTED = [19, 23, 23, 29, 26]

for (i, e) in zip(INPUTS_S, EXPECTED)
    @test compute(i) == e
end


INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))