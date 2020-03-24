using PorousMaterials
using CSV


function gcmc_simulation_cluster_data(pressure_pa, n; n_subcycles=100)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)

    molecules = [Molecule("TIP4P-$(i)") for i in n:-1:2]

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar
    # pressure = 1.0

    # conduct grand-canonical Monte Carlo simulation
    results, molecules = gcmc_simulation_clusters(framework, temperature, pressure, forcefield;
                n_subcycles=n_subcycles, write_adsorbate_snapshots=true, snapshot_frequency=1,
                molecule_clusters=molecules)

    e_df = CSV.File("energy_log_tip4pN_$(float(pressure_pa))_n$(n_subcycles).tsv") |> DataFrame
    return results, molecules, e_df
end
