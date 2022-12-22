using Printf, Test

using aocJulia: helpers


function monkey_calc(monkeys, name)
    if isa(monkeys[name], Number)
        return monkeys[name]
    else
        (op, n1, n2) = monkeys[name]
        return op(monkey_calc(monkeys, n1), monkey_calc(monkeys, n2))
    end
end


function compute(s)
    ops = Dict(
        "+" => (a, b) -> a + b,
        "-" => (a, b) -> a - b,
        "/" => (a, b) -> a / b,
        "*" => (a, b) -> a * b,
    )
    

    monkeys = Dict()

    for line in split(chomp(s), "\n")
        line_split = [r.match for r in eachmatch(r"(\w+|\d+|[\+\-\*\/])", line)]
        if length(line_split) == 2
            (name, num) = line_split
            monkeys[name] = parse(Int, num)
        else
            (name, m1, op, m2) = line_split
            monkeys[name] = (ops[op], m1, m2)
        end
    end

    return monkey_calc(monkeys, "root")

    name = "root"
end


INPUTS_S = """root: pppw + sjmn
dbpl: 5
cczh: sllz + lgvd
zczc: 2
ptdq: humn - dvpt
dvpt: 3
lfqf: 4
humn: 5
ljgn: 2
sjmn: drzm * dbpl
sllz: 4
pppw: cczh / lfqf
lgvd: ljgn * ptdq
drzm: hmdt - zczc
hmdt: 32
"""
EXPECTED = 152

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@printf("%.1f", compute(INPUT_TXT))
