using Test

using aocJulia: helpers

struct Robots
    ore
    clay
    obs
    geode
end


struct Materials
    ore
    clay
    obs
    geode
end


function best_geodes(instructions)
        (ore_ore, clay_ore, obs_ore, obs_clay, geode_ore, geode_obs) = instructions

        max_ore = max(
            ore_ore,
            clay_ore,
            obs_ore,
            geode_ore
        )

        todo = [[
            0,  # time
            Robots(1, 0, 0, 0),
            Materials(0, 0, 0, 0)
        ]]
        seen = Set()
        best_geo_at_t = zeros(33)
        while length(todo) > 0
            (t, r, m) = popfirst!(todo)

            m = Materials(
                min(max_ore * (32 - t), m.ore),
                min(obs_clay * (32 - t), m.clay),
                min(geode_obs * (32 - t), m.obs),
                m.geode
            )

            r = Robots(
                min(r.ore, max_ore),
                min(r.clay, obs_clay),
                min(r.obs, geode_obs),
                r.geode
            )

            if (t, r, m) in seen
                continue
            else
                push!(seen, (t, r, m))
            end
            
            best_geo_at_t[t + 1] = max(best_geo_at_t[t + 1], m.geode)

            if t == 32
                continue
            end
            
            # Create a new branch for each possible robot buy at this point
            if m.obs >= geode_obs && m.ore >= geode_ore
                push!(todo, [
                    t + 1,
                    Robots(r.ore, r.clay, r.obs, r.geode + 1),
                    Materials(
                        m.ore + r.ore - geode_ore,
                        m.clay + r.clay,
                        m.obs + r.obs - geode_obs,
                        m.geode + r.geode
                    )
                ])
                # Prune branches, if can buy geode then always do
                continue
            end
            if m.clay >= obs_clay && m.ore >= obs_ore
                push!(todo, [
                    t + 1,
                    Robots(r.ore, r.clay, r.obs + 1, r.geode),
                    Materials(
                        m.ore + r.ore - obs_ore,
                        m.clay + r.clay - obs_clay,
                        m.obs + r.obs,
                        m.geode + r.geode
                    )
                ])
            end
            if m.ore >= clay_ore
                push!(todo, [
                    t + 1,
                    Robots(r.ore, r.clay + 1, r.obs, r.geode),
                    Materials(
                        m.ore + r.ore - clay_ore,
                        m.clay + r.clay,
                        m.obs + r.obs,
                        m.geode + r.geode
                    )
                ])
            end
            if m.ore >= ore_ore
                push!(todo, [
                    t + 1,
                    Robots(r.ore + 1, r.clay, r.obs, r.geode),
                    Materials(
                        m.ore + r.ore - ore_ore,
                        m.clay + r.clay,
                        m.obs + r.obs,
                        m.geode + r.geode
                    )
                ])
            end
            
            # 0 buy branch
            push!(todo, [
                t + 1,
                Robots(r.ore, r.clay, r.obs, r.geode),
                Materials(
                    m.ore + r.ore,
                    m.clay + r.clay,
                    m.obs + r.obs,
                    m.geode + r.geode
                )
            ])
        end
    return best_geo_at_t[33]
end


function compute(s)
    blueprints = Dict()
    for line in split(chomp(s),"\n")
        (id, ore_ore, clay_ore, obs_ore, obs_clay, geode_ore, geode_obs) = [parse(Int, m.match) for m in eachmatch(r"(\d+)", line)]
        if id <= 3
            blueprints[id] = best_geodes([ore_ore, clay_ore, obs_ore, obs_clay, geode_ore, geode_obs])
        end
    end
    return prod([geo for (id, geo) in blueprints])
end


INPUTS_S = """
Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. Each geode robot costs 2 ore and 7 obsidian.
Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. Each geode robot costs 3 ore and 12 obsidian.
"""
EXPECTED = 33

@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))