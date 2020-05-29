include("GCMCTrials.jl")

rep = 1
for cluster_size = 2:21
    molecule_name = "TIP4P-$(cluster_size)"
    df = trial_insertions_data(molecule_name, 4500, 10, file_suffix="$rep")
end





#
# include("ReshapeMoleculesNto1.jl")
#
# checkpoint_file = "$(chk_prefix).jld2"
# @load checkpoint_file checkpoint
# ## split molecules
# molecules = reshape_h2o_cluster_to_single_h2os_from_checkpoint(checkpoint)
#
#
#
# args = Dict(
#     :molecules => molecules,
#     :batch_move_type => 1,
#     :n_burn_cycles => 0,
#     :n_sample_cycles => 800,
#     :n_subcycles => 1000,
#     :write_adsorbate_snapshots => false,
#     :snapshot_frequency => 50,
#     :molecule_multiplier => 1,
#     :write_checkpoints => true,
#     :checkpoint_frequency => 50,
#     :n_cluster_intraenergy => 0.0
# )
# #
# # include("../../n_mc2.jl")
