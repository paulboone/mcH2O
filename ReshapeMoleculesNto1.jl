using DataFrames
using JLD2
using PorousMaterials
using PrettyPrinting

"""

    h2o_molecules = reshape_h2o_cluster_to_single_h2os_from_checkpoint(checkpoint, molecule="TIP4P-1")

Takes all the adsorbed molecules (typically an H2O N-cluster) from a checkpoint file and splits each
N-cluster into its individual H2O molecules (typically, a TIP4P-1).
"""
function reshape_h2o_cluster_to_single_h2os_from_checkpoint(checkpoint; verbose=false)
    molecule="TIP4P-1"
    h2o_singles = Molecule[]
    for m in checkpoint["molecules"]
        verbose && println("$(m.atoms.n_atoms) h2os in molecule")
        push!(h2o_singles, h2o_singles_from_n_cluster(m, molecule)...)
    end

    verbose && println("resulting h2os: $(size(h2o_singles)) ")

    return h2o_singles
end

function h2o_singles_from_n_cluster(m, molecule)
    # each TIP4P is ONE atom, the oxygen, + three charges, two where the hydrogens should be and
    # one that is offset from the oxygen. So each TIP4P H2O has one atom and three charges.
    h2o_singles = Molecule[]
    for h2o_index in 1:m.atoms.n_atoms
        atoms = Atoms([m.atoms.species[1]], m.atoms.xf[:, h2o_index:h2o_index])

        # 3 charges per H2O
        chargerange = 3*h2o_index - 2:h2o_index * 3
        charges = Charges(3, [-1.04, 0.52, 0.52], m.charges.xf[:, chargerange])
        com = atoms.xf[:, 1]
        new_h2o = Molecule(Symbol(molecule), atoms, charges, com)

        push!(h2o_singles, new_h2o)
    end
    return h2o_singles
end

"""
    checkpoint_summary(checkpoint)

Utility function to output checkpoint.
"""
function checkpoint_summary(checkpoint::Dict)
    chk2 = deepcopy(checkpoint)
    delete!(chk2, "molecules")
    delete!(chk2, "gcmc_stats")
    pprint(chk2)
end


"""
    df = tip4P_checkpoint_to_df(checkpoint)

Takes a checkpoint containing H2O TIP4P molecules (or clusters) and returns a dataframe of
[atom type, x, y, z]. In conjunction with df_to_xyz(), you can easily convert a checkpoint to an xyz
for display in iRaspa. e.g:

    @load path_to_checkpoint checkpoint
    df_to_xyz(tip4P_checkpoint_to_df(checkpoint), "test.xyz")

"""
function tip4P_checkpoint_to_df(checkpoint)
    h2o_singles = reshape_h2o_cluster_to_single_h2os_from_checkpoint(checkpoint)
    df = DataFrame(atom=String[], x=Float64[], y=Float64[], z=Float64[])
    for m in h2o_singles
        push!(df, ("O", m.atoms.xf...))
        push!(df, ("H", m.charges.xf[:,1]...))
        push!(df, ("H", m.charges.xf[:,2]...))
        push!(df, ("H", m.charges.xf[:,3]...))
    end
    return df
end

function df_to_xyz(df, xyz_path)
    open(xyz_path, "w") do f
        println(f, size(df, 1))
        println(f)
        CSV.write(f, df; delim=" ", append=true)
    end
end
