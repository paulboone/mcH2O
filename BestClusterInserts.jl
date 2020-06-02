using DataFrames

include("GCMCTrials.jl")

function run_trials(num_trials=10; rep=1)

    for cluster_size = 2:21
        molecule_name = "TIP4P-$(cluster_size)"
        df = trial_insertions_data(molecule_name, 4500, num_trials, file_suffix="$rep")
    end
end


function read_trial_results(path; num_trials=10000)
    df = DataFrame(:cluster_size => zeros(Int, 100),
                   :energy => zeros(100),
                   :rep => zeros(Int, 100))

    i = 1
    for cluster_size = 2:21
        for rep = 1:5
            molecule_name = "TIP4P-$(cluster_size)"
            checkpoint_file = "molchk-$(molecule_name)_$(num_trials)_$rep.jld2"
            @load "$(path)$(checkpoint_file)" checkpoint

            df.cluster_size[i] = cluster_size
            df.energy[i] = checkpoint["best_energy"]
            df.rep[i] = rep
            i += 1
        end
    end
    return df
end

function plot_energy_vs_cluster_size(df)
    p = plot(df.cluster_size, df.energy, seriestype=:scatter, xlabel="H2O Cluster Size", ylabel="Energy [K]",
            dpi=300, size=(600, 600), legend=false)
    savefig(p, "energy-vs-clustersizeN.png")
end

function best_trial(df)
    return sort(df, (:cluster_size, :energy))[1:5:end,:]
end
