

using PorousMaterials


function gcmc_batchinsert_data(molecule_name, pressure_pa, n_subcycles; batch_moves=false)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar
    # pressure = 1.0

    # conduct grand-canonical Monte Carlo simulation
    results, molecules = gcmc_simulation(framework, molecule, temperature, pressure, forcefield,
                n_burn_cycles=4, n_sample_cycles=16, n_subcycles=n_subcycles,
                write_adsorbate_snapshots=true, snapshot_frequency=1,
                batch_moves=batch_moves)

    e_df = CSV.File("energy_log_$(molecule_name)_$(pressure_pa)_n$(n_subcycles)_$(batch_moves ? "batch" : "baseline").tsv") |> DataFrame
    return results, molecules, e_df
end
