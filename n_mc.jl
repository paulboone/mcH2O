

using PorousMaterials


function n_mc(molecule_name, pressure_pa, n_subcycles; batch_moves=false)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar
    # pressure = 1.0

    # conduct grand-canonical Monte Carlo simulation
    results, molecules = gcmc_simulation(framework, molecule, temperature, pressure, forcefield,
                n_burn_cycles=1, n_sample_cycles=5, n_subcycles=n_subcycles,
                write_adsorbate_snapshots=true, snapshot_frequency=1,
                batch_moves=batch_moves)

end

pressure_pa = 4500.0
molecule_name = "H2O_tip4p"
n_subcycles = 4000
batch_moves = true
# molecule_name = "CO2"

n_mc(molecule_name, pressure_pa, n_subcycles, batch_moves=batch_moves)
e_df = DataFrames.readtable("energy_log_$(molecule_name)_$(pressure_pa)_n$(n_subcycles)_$(batch_moves ? "batch" : "baseline").tsv", )
e_df
