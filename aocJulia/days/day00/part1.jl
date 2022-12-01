using Test

using aocJulia: helpers


function compute(s)
    return parse.(Int, split(s))
end


INPUTS_S = ""
EXPECTED = ""

# @test compute(EXPECTED) == INPUTS_S

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))