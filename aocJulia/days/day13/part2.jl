using Chain, Test

using aocJulia: helpers


function get(x, i)
    checkbounds(Bool, x, i) && return x[i]
    return nothing
end


function compare(l::Number, r::Number)
    l < r && return true
    l > r && return false
    return nothing
end


function compare(l::Number,  r::Vector)
    return compare([l], r)
end


function compare(l::Vector,  r::Number)
    return compare(l, [r])
end


function compare(l::Vector, r::Vector)
    # compare([], []) case - never occurs?
    all(isempty.((l, r))) && return true

    for i in 1:max(length(l), length(r))
        # Get next values of list
        ri = get(r, i)
        li = get(l, i)

        # Check if either ran out and return
        isnothing(ri) && return false
        isnothing(li) && return true

        # Compare values and return if determinor found
        comp = compare(li, ri)
        !isnothing(comp) && return comp
    end
end


function compute(s)
    # Evaluate all nested lists
    packets = @chain s begin
        chomp
        replace("\n\n" => "\n")
        split("\n")
        Meta.parse.(_)
        eval.(_)
    end
    
    # Add dividors to package
    divider_packets = ([[2]], [[6]])
    push!(packets, divider_packets...)

    # Sort, using compare() to return if l < r
    sort!(packets, lt=compare)

    # Find indices of dividors and multiply
    dividers  = findall(x -> x ∈ divider_packets, packets)
    return prod(dividers)
end


INPUTS_S = """[1,1,3,1,1]
[1,1,5,1,1]

[[1],[2,3,4]]
[[1],4]

[9]
[[8,7,6]]

[[4,4],4,4]
[[4,4],4,4,4]

[7,7,7,7]
[7,7,7]

[]
[3]

[[[]]]
[[]]

[1,[2,[3,[4,[5,6,7]]]],8,9]
[1,[2,[3,[4,[5,6,0]]]],8,9]
"""
EXPECTED = 140

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))