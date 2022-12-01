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
end


function read_input(fpath)
    read(joinpath(fpath, "input.txt"), String)
end

end