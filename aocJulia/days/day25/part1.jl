using Test

using aocJulia: helpers


function from_snafu(s)
    snafu = Dict(
        '-' => -1,
        '=' => -2,
    )
    fives = [5 ^ (length(s) - i) for i=1:length(s)]

    tot = 0
    for (c, n) in zip(s, fives)
        number = get(snafu, c, nothing)
        if isnothing(number)
            number = parse(Int, c)
        end
        tot += number * n
    end

    return tot
end


function to_snafu(n::Number)
    # Only use regular digits 2, 1, 0
    # If need 3 or 4, then increase n and add -- or -
    
    digits = []

    while n > 0
        push!(digits, n % 5)
        n = n ÷ 5
    end

    snafu = ""
    remaining = 0
    for d in digits
        d += remaining
        if d in (0, 1, 2)
            c = "$d"
            remaining = 0
        elseif d == 3
            c = "="
            remaining = 1
        elseif d == 4
            c = "-"
            remaining = 1
        elseif d == 5
            c = "0"
            remaining = 1
        end
        snafu *= c
    end
    return reverse(snafu)
end


function to_snafu(s)
    return to_snafu(parse(Int, s))
end


function compute(s)
    total = 0
    for line in split(chomp(s), "\n")
        total += from_snafu(line)
    end
    return to_snafu(total)
end



INPUTS_S = """1=-0-2
12111
2=0=
21
2=01
111
20012
112
1=-1=
1-12
12
1=
122
"""
EXPECTED = "2=-1=0"

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))