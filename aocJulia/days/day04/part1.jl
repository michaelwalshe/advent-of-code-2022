using Pipe, Test

using aocJulia: helpers


function compute(s)
    lines = @pipe s |> split |> split.(_, ",") |> map.(x->split(x, "-"), _)
    n = 0
    for pair in lines
        ((a, b), (c, d)) = (parse.(Int, e) for e in pair)
        if (
            a<=c<=d<=b
            || c<=a<=b<=d
        )
            n +=1 
        end
    end
    return n
end


INPUTS_S = """
2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8
"""
EXPECTED = 2

# @test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))