module helpers
using HTTP

const YEAR = 2022
const ROOT = joinpath(splitpath(Base.source_path())[1:(end - 2)]...)

function _get_cookie_headers()
    contents = open(joinpath(ROOT, ".env")) do f
        read(f, String)
    end
    return Dict("Cookie" => contents)
end

function get_input(day)
    url = "https://adventofcode.com/$(YEAR)/day/$(day)/input"
    req = HTTP.get(url, _get_cookie_headers())
    return String(req.body)
end


function create_day(day)
    day_name = "day$(lpad(day, 2, "0"))"

    if isdir(joinpath(ROOT, "days", day_name))
        error("Day directory $(day_name) exists in $(ROOT)")
    end

    cp(
        joinpath(ROOT, "days", "day00"),
        joinpath(ROOT, "days", day_name)
    )

    write(joinpath(ROOT, "days", day_name, "input.txt"), get_input(day))

    return nothing
end


function read_input(fpath)
    read(joinpath(fpath, "input.txt"), String)
end


function format_hash_coords(coords)
    min_x = minimum(p -> p[1], coords)
    max_x = maximum(p -> p[1], coords)
    min_y = minimum(p -> p[2], coords)
    max_y = maximum(p -> p[2], coords)

    g = ""
    for y in min_y:(max_y+1)
        for x in min_x:(max_x+1)
            if (x, y) in coords
                g *= "#"
            else
                g *= "."
            end
        end
        g *= "\n"
    end
    return g
end

end