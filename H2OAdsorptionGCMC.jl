

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
