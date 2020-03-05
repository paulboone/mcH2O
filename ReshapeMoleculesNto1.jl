using JLD2
using PorousMaterials
using PrettyPrinting


function load_molecules_from_checkpoint(checkpoint, molecule="TIP4P-1")

    h2o_singles = Molecule[]

    for m in checkpoint["molecules"]
        println("$(m.atoms.n_atoms) h2os in molecule")
        for h2o_index in 1:m.atoms.n_atoms

            atoms = Atoms([m.atoms.species[1]], m.atoms.xf[:, h2o_index:h2o_index])

            # 3 charges per H2O
            chargerange = 3*h2o_index - 2:h2o_index * 3
            charges = Charges(3, [-1.04, 0.52, 0.52], m.charges.xf[:, chargerange])
            com = atoms.xf[:, 1]
            new_h2o = Molecule(Symbol(molecule), atoms, charges, com)

            push!(h2o_singles, new_h2o)
        end
    end

    println("resulting h2os: $(size(h2o_singles)) ")

    return h2o_singles
end

function checkpoint_summary(checkpoint::Dict)
    chk2 = deepcopy(checkpoint)
    delete!(chk2, "molecules")
    delete!(chk2, "gcmc_stats")
    pprint(chk2)
end
