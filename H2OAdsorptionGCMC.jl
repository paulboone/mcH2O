

using PorousMaterials


function trial_probability_model(molecule_name)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = 1.0 # bar

    # conduct grand-canonical Monte Carlo simulation
    results, molecules = gcmc_simulation(framework, molecule, temperature, pressure, forcefield,
                n_burn_cycles=1, n_sample_cycles=1)

    # returns dictionary for easy querying
    results["⟨N⟩ (molecules/unit cell)"]
    results["Q_st (K)"]

end

trial_probability_model("H2O_tip4p")
df = DataFrame(CSV.File("inserted_adsorbates_H2O_tip4p.csv", header=["molecule_#", "E_gh_vdw","E_gh_q", "E_gg_vdw", "E_gg_q", "ins", "ins_empty", "ins_empty2", "ins_full","x", "y", "z"]))


df.E_gg = df.E_gg_vdw + df.E_gg_q
df.E_gh = df.E_gh_vdw + df.E_gh_q
df.E = df.E_gg + df.E_gh
adsorbates = df[:, Not([:x, :y, :z])]

probs = readdlm("adsorbate_prob_by_molecule_num_H2O_tip4p.csv", '\t', Float64, '\n')
# DataFrame(CSV.File("adsorbate_prob_by_molecule_num_H2O_tip4p.csv", header=false))


adsorbates, probs
