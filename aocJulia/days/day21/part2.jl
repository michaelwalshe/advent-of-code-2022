using Printf, Test

using aocJulia: helpers


function compute(s)
    ops = Dict(
        "+" => (a, b) -> a + b,
        "-" => (a, b) -> a - b,
        "/" => (a, b) -> a / b,
        "*" => (a, b) -> a * b,
    )
    revops = Dict(
        "+" => (a, b) -> a - b,
        "-" => (a, b) -> a + b,
        "/" => (a, b) -> a * b,
        "*" => (a, b) -> a ÷ b,
    )

    monkeys = Dict()

    for line in split(chomp(s), "\n")
        line_split = [r.match for r in eachmatch(r"(\w+|\d+|[\+\-\*\/])", line)]
        if length(line_split) == 2
            (name, num) = line_split
            name == "humn" && continue
            monkeys[name] = parse(Int, num)
        else
            (name, m1, op, m2) = line_split
            monkeys[name] = (op, m1, m2)
        end
    end

    function monkey_calc(name)
        if isa(monkeys[name], Number)
            return monkeys[name]
        else
            (op, n1, n2) = monkeys[name]
            return ops[op](monkey_calc(n1), monkey_calc(n2))
        end
    end

    (_, left, right) = monkeys["root"]
    val = monkey_calc(right)

    operation = monkeys[left]
    try
        while true
            (op, n1, n2) = operation

            found_exception = false
            local lhs, rhs
            try
                lhs = monkey_calc(n1)
            catch
                found_exception = true
                rhs = monkey_calc(n2)

                val = revops[op](val, rhs)

                operation = monkeys[n1]
            end
            if !found_exception
                if op == "-"
                    val -= lhs
                    val *= -1
                elseif op == "+"
                    val -= lhs
                elseif op == "*"
                    val = val ÷ lhs
                elseif op == "/"
                    val = lhs ÷ right_val
                end

                operation = monkeys[n2]
            end
        end
    catch
        return val
    end
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
EXPECTED = 301

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))

@printf("%.1f", compute(INPUT_TXT))
