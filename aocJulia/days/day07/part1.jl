using Test

using aocJulia: helpers

global ID = 0


mutable struct File
    name
    size
    parent
    id
    function File(name, size, parent)
        global ID += 1
        new(name, size, parent, ID)
    end
end
File(name, size) = File(name, size, nothing)


mutable struct Directory
    name
    children::Vector{Any}
    parent
    id
    function Directory(name, children, parent)
        global ID += 1
        new(name, children, parent, ID)
    end
end
Directory(name) = Directory(name, [], nothing)


function get_files(dir::Directory)
    files = []
    for child in dir.children
        if isa(child, File)
            push!(files, child)
        else
            append!(files, get_files(child))
        end
    end
    return files
end


function get_dirs(dir::Directory)
    dirs = []
    for child in dir.children
        if isa(child, Directory)
            push!(dirs, child)
            append!(dirs, get_dirs(child))
        end
    end
    return dirs
end

# Only files have size builtin
function get_size(f::File)
    return f.size
end


# Calculate size of subdirectories
function get_size(dir::Directory)
    return dir |> get_files .|> get_size |> sum
end


# Add a child to a directory
function add_child!(dir, child::Union{Directory, File})
    child.parent = dir.id
    push!(dir.children, child)
end


function get_child_dir(dir, id::Number)
    if dir.id == id
        return dir
    end

    found = nothing
    for child in dir.children
        if !isa(child, Directory)
            continue
        end
        if child.id == id
            return child
        else
            found = get_child_dir(child, id)
        end
        if !isnothing(found)
            break
        end
    end
    return found
end

function get_child_dir(dir, name::String)
    for child in dir.children
        if isa(child, Directory) && child.name == name
            return child
        end
    end
end


function compute(s)
    commands = []
    outputs = []
    output = []
    # First, strip out all commands an their respective outputs
    for line in split(chomp(s), "\n")
        # If command, push previous output
        if startswith(line, raw"$")
            push!(outputs, output)
            output = []
        end

        # Parse line and add to appropriate container
        if startswith(line, raw"$ cd")
            push!(commands, line[3:end])
        elseif startswith(line, raw"$ ls")
            push!(commands, line[3:end])
        elseif startswith(line, "dir")
            push!(output, Directory(line[5:end]))
        else
            (size, name) = split(line)
            push!(output, File(name, parse(Int, size)))
        end
    end
    push!(outputs, output)

    # ==== #
    # Now iterate through commands, building a directory as we go
    filesystem = Directory("/")
    dir = filesystem
    for (cmd, output) in zip(commands[2:end], outputs[3:end])
        if startswith(cmd, "cd")
            # Change directory...
            newdir = cmd[4:end]
            if newdir == ".."
                # Find parent in filesystem
                dir = get_child_dir(filesystem, dir.parent)
            else
                dir = get_child_dir(dir, String(newdir))
            end
        else
            # Only other command is ls, so add children to this dir
            for newchild in output
                add_child!(dir, newchild)
            end
        end
    end
    # Calculate filesystem size
    sizes = Dict(filesystem.id => get_size(filesystem))
    for dir in get_dirs(filesystem)
        sizes[dir.id] = get_size(dir)
    end
    # return filter(p -> p.second <= 100000, sizes) |> values |> sum
    return sizes
end


INPUTS_S = raw"""
$ cd /
$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
$ cd a
$ ls
dir e
29116 f
2557 g
62596 h.lst
$ cd e
$ ls
584 i
$ cd ..
$ cd ..
$ cd d
$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k
"""
EXPECTED = 95437 

s = compute(INPUTS_S)


@test compute(INPUTS_S) == EXPECTED

INPUT_TXT = helpers.read_input(dirname(Base.source_path()))
println(compute(INPUT_TXT))
