
using CSV
using DataFrames
using Glob


function convert_tip4pNcluster_data(searchglob; dir="h2o-n-clusters", outputdir="data")
    chargemap = Dict("O" => -1.04, "H" => 0.52)
    mkpath(joinpath(dir, outputdir))

    for xyz_path = glob(searchglob, dir)
        molecule_path = joinpath(dir, "data", (xyz_path |> basename |> splitext)[1])
        mkpath(molecule_path)
        df = DataFrame(CSV.File(xyz_path; header=[:atom, :x, :y, :z], skipto=3, delim=" ", ignorerepeated=true,))
        # write lennard_jones_spheres.csv
        lj = deepcopy(df[df.atom .== "O", :])
        lj.atom .= "O_h2o"
        CSV.write(joinpath(molecule_path, "lennard_jones_spheres.csv"), lj)

        # write point_charges.csv
        charges = deepcopy(df)
        for i in 1:(size(df,1) ÷ 3)
            idxh2o = 3(i-1) + 1
            println(i, idxh2o)
            rO  = convert(Array, df[idxh2o + 0, [:x, :y, :z]])
            rH1 = convert(Array, df[idxh2o + 1, [:x, :y, :z]])
            rH2 = convert(Array, df[idxh2o + 2, [:x, :y, :z]])

            tip4p_h_axial = 0.58588227661829499395
            tip4p_q_axial_pos = 0.15
            newpos = rO + ((rH1 - rO) + (rH2 - rO)) * tip4p_q_axial_pos / (2*tip4p_h_axial)
            println(rO, " => ", newpos)
            println(sqrt(sum((newpos - rO).^2)))
            charges[idxh2o, [:x, :y, :z]] .= newpos
        end

        charges.atom =  broadcast(a -> chargemap[a], charges.atom)
        rename!(charges, Dict("atom" => "q"))
        CSV.write(joinpath(molecule_path, "point_charges.csv"), charges)
    end
end
