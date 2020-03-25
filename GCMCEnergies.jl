
using CSV, DataFrames, VegaLite
using Plots

using PorousMaterials
include("ReshapeMoleculesNto1.jl")

"""
    energies = h2o_cluster_intra_energy(molecule_name, pressure_pa, max_trials)
"""
function h2o_cluster_intra_energy(framework_name, molecule_name="TIP4P-2")
    framework = Framework(framework_name)
    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    m = Molecule(molecule_name)
    m1 = Molecule("TIP4P-1")
    h2o_singles = h2o_singles_from_n_cluster(m, m1)
    # println("h2o_singles: ", h2o_singles)
    # println("h2o_1: ", m1)
    return gcmc_energy(framework, m1, h2o_singles, forcefield)
end

function calc_all_TIP4P_n_cluster_energies(framework_name="empty_box_30.cssr")
    a = zeros(21)
    for i in range(1,21)
        e = h2o_cluster_intra_energy(framework_name, "TIP4P-$i")
        a[i] = (e.guest_guest.vdw + e.guest_guest.coulomb) * 0.00831435
    end
    return a
end
