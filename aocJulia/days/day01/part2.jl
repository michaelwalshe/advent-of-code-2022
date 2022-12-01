using Test

using aocJulia: helpers


function compute(s)
    elfs = Vector{Int}()
    elf = Vector{Int}()
    for line in split(s, "\n")
        if line != ""
            append!(elf, parse(Int, line))
        else
            append!(elfs, sum(elf))
            elf = Vector{Int}()
        end
    end
    return sort(elfs, rev=true)[1:3] |> sum
end



INPUTS_S = """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000
"""
EXPECTED = 45000

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

println(compute(INPUT_TXT))