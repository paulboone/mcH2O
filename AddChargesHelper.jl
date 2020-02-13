

using PorousMaterials


zif8charges = Dict([(:Zn1, 0.720),
                    (:C1, 0.419),
                    (:C2, -0.196),
                    (:C3, -0.601),
                    (:H2, 0.168),
                    (:H3A, 0.168),
                    (:H3B, 0.168),
                    (:H3C, 0.168),
                    (:N1, -0.313),
                    (:N_n2, -0.482),
                    (:N_com,  0.964),
                    (:C_co2,  0.700),
                    (:O_co2, -0.350),])


# e.g. :
# f = Framework("ZIF-8.cif")
# nf = add_charges_to_framework(f, zif8charges)
# write_cif(nf, "ZIF-8q.cif")
function add_charges_to_framework(f, chargedict)
    atom_charges = map(a -> chargedict[a], f.atoms.species)
    charges = Charges(atom_charges, f.atoms.xf)
    return Framework(f.name, f.box, f.atoms, charges, f.bonds, f.symmetry, f.space_group, f.is_p1)
end
