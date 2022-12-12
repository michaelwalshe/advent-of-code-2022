using Test

using aocJulia: helpers


mutable struct Monkey
    items
    operation
    divisor
    true_monkey
    false_monkey
    inspections
end


function compute(s)
    monkeys = []
    for m in split(chomp(s), "\n\n")
        local items, divisor, true_monkey, false_monkey
        for (i, line) in enumerate(split(m, "\n"))
            if i == 2
                items = Meta.parse("[" * line[18:end] * "]") |> eval
            elseif i == 3
                Meta.parse("global operation = old -> " * line[19:end]) |> eval
            elseif i == 4
                divisor = parse(Int, match(r"\d+", line).match)
            elseif i == 5
                true_monkey = parse(Int, match(r"\d+", line).match)
            elseif i == 6
                false_monkey = parse(Int, match(r"\d+", line).match)
            end
        end
        monkey = Monkey(
            BigInt.(items),
            operation,
            divisor,
            true_monkey,
            false_monkey,
            BigInt(0)
        )
        push!(monkeys, monkey)
    end

    for round in 1:10000
        for i in eachindex(monkeys)
            for _ in eachindex(monkeys[i].items)
                monkeys[i].inspections += 1
                func = monkeys[i].operation
                worry = Base.invokelatest(func, popfirst!(monkeys[i].items))
                worry = floor(worry / 3)
                if worry % monkeys[i].divisor == 0
                    push!(monkeys[monkeys[i].true_monkey + 1].items, worry)
                else
                    push!(monkeys[monkeys[i].false_monkey + 1].items, worry)
                end
            end
        end
    end

    sort!(monkeys, by=m->m.inspections, rev=true)
    # return monkeys
    return monkeys[1].inspections * monkeys[2].inspections
end


INPUTS_S = """Monkey 0:
  Starting items: 79, 98
  Operation: new = old * 19
  Test: divisible by 23
    If true: throw to monkey 2
    If false: throw to monkey 3

Monkey 1:
  Starting items: 54, 65, 75, 74
  Operation: new = old + 6
  Test: divisible by 19
    If true: throw to monkey 2
    If false: throw to monkey 0

Monkey 2:
  Starting items: 79, 60, 97
  Operation: new = old * old
  Test: divisible by 13
    If true: throw to monkey 1
    If false: throw to monkey 3

Monkey 3:
  Starting items: 74
  Operation: new = old + 3
  Test: divisible by 17
    If true: throw to monkey 0
    If false: throw to monkey 1
"""
EXPECTED = 10605

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))