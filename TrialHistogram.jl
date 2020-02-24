
using CSV, DataFrames, VegaLite
using Plots

using PorousMaterials


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

function trial_histogram_plots(path)

    trials = DataFrame(CSV.File(path))

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


function trial_insertions_data(molecule_name, pressure_pa, max_trials)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar

    # conduct grand-canonical Monte Carlo simulation
    gcmc_trial_insertions(framework, molecule, temperature, pressure, forcefield, max_trials=max_trials)

end
