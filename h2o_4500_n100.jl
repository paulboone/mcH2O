
temperature = 298.0 # K
pressure_pa = 4500.0
framework_name = "ZIF-8q.cif"
molecule_name = "H2O_tip4p"

args = Dict(
    :batch_moves => true,
    :n_burn_cycles => 4,
    :n_sample_cycles => 16,
    :n_subcycles => 10,
    :write_adsorbate_snapshots => true,
    :snapshot_frequency => 1
)
include("n_mc2.jl")
