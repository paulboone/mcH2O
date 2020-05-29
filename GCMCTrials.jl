
using CSV, DataFrames, VegaLite
using Plots

using PorousMaterials

"""
    trials_df = trial_insertions_data(molecule_name, pressure_pa, max_trials)

Helper that runs N insertion trials for ZIF-8 with all our default settings (Dreiding, 298K) and
returns a trials dataframe containing the energy, the insertion probability, and the coordinates of
each trial.
"""
function trial_insertions_data(molecule_name, pressure_pa, max_trials; molecule_multiplier=1, file_suffix="")

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar

    # conduct grand-canonical Monte Carlo simulation
    return gcmc_trial_insertions(framework, molecule, temperature, pressure, forcefield,
                max_trials=max_trials, molecule_multiplier=molecule_multiplier,
                file_suffix=file_suffix)
end


"""
This is deprecated in favor of trial_histogram_plots below.
"""
function trial_histogram_vegalite(path)

    trials = DataFrame(CSV.File(path))

    trials.log_ins = log10.(clamp.(trials.insprob, 1e-4, 1e+4))
    sort!(trials, :log_ins)

    plots = [
        @vlplot(:bar, title=path,
                      x={:log_ins, bin={maxbins=30}, title="log(insertion probability)",
                         scale={domain=[-4, 4]}},
                      y={"sum(insprob)", title="Sum(cycles to deletion)"});
        @vlplot(:bar, x={:log_ins, bin={maxbins=30}, title="log(insertion probability)",
                         scale={domain=[-4, 4]}},
                      y={"count()", title="# trials"})
    ]

    # scale={domain=[0, 10000 * 10]}

    trials |> plots |> display
    trials
end

function trial_histogram_plots(;path=nothing, df=nothing)
    if ! isnothing(path)
        trials = DataFrame(CSV.File(path))
    elseif ! isnothing(df)
        trials = deepcopy(df)
    else
        error("either path or df must be passed to trial_histogram_plots")
    end

    trials.log_ins = log10.(clamp.(trials.insprob, 1e-4, 1e+4))
    sort!(trials, :log_ins)
    bin_range = -4:0.5:4

    plot_count = histogram(trials.log_ins, bins=bin_range, legend=false,
                    xlabel="log(insertion probability)",
                    ylabel="# trials", ylims=[0,1000])
    vline!(plot_count, [0], lc="grey", lw=2, label="")

    plot_ctd = histogram(trials.log_ins, bins=bin_range, weights=trials.insprob,
                        xlabel="log(insertion probability)", ylabel="sum(cycles to deletion)",
                        ylims=[0,1000], legend=false)
    vline!(plot_ctd, [0], lc="grey", lw=2, label="")

    plot(plot_count, plot_ctd, size=(800,800), dpi=300, layout=grid(2,1))
end
