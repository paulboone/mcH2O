
using CSV
using DataFrames
using Glob

dir = "h2o-n-clusters"
mkpath(joinpath(dir, "data"))

for xyz_path = glob("*.xyz", dir)
    molecule_path = joinpath(dir, "data", (xyz_path |> basename |> splitext)[1])
    mkpath(molecule_path)
    df = DataFrame(CSV.File(xyz_path; header=[:atom, :x, :y, :z], skipto=3, delim=" ", ignorerepeated=true,))

    # write lennard_jones_spheres.csv
    lj = deepcopy(df[df.atom .== "O", :])
    lj.atom .= "O_h2o"
    CSV.write(joinpath(molecule_path, "lennard_jones_spheres.csv"), lj)

    # write point_charges.csv
    charges = deepcopy(df)
    charges.atom =  broadcast(a -> chargemap[a], charges.atom)
    rename!(charges, Dict("atom" => "q"))
    CSV.write(joinpath(molecule_path, "point_charges.csv"), charges)
end
