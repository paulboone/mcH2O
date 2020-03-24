
import CSV
using PorousMaterials


"""
    results, molecules, e_df = gcmc_batchinsert_data(molecule_name, pressure_pa, n_subcycles; batch_moves=false)

Helper that runs a GCMC for ZIF-8 with all our default settings (Dreiding, 298K) and returns the
results (from PorousMaterials.jl), the adsorbed molecules, and the energy data frame from loading
the energy_log.

Can run in two modes:
- batch_moves=false: normal probability of MC moves
- batch_moves=true: "batches" MC moves, e.g. runs 1000 inserts, 1000 moves, 1000 deletes, 1000 moves.
"""
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
                n_burn_cycles=4, n_sample_cycles=4, n_subcycles=n_subcycles,
                write_adsorbate_snapshots=true, snapshot_frequency=1,
                batch_moves=batch_moves)

    e_df = CSV.File("energy_log_$(molecule_name)_$(float(pressure_pa))_n$(n_subcycles)_$(batch_moves ? "batch" : "baseline").tsv") |> DataFrame
    return results, molecules, e_df
end
