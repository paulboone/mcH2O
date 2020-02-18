
using CSV, DataFrames, VegaLite


function trial_histogram(path)

    trials = DataFrame(CSV.File(path, header=["index", "E_gh_vdw","E_gh_q", "E_gg_vdw", "E_gg_q", "ins", "ins_empty", "ins_empty", "ins_full", "x", "y", "z"]

    trials.ins_del = log10.(max.(1e-4,min.(1.0,trials.ins) ./ min.(1.0, trials.del)))
    trials.cycles_to_deletion = 1 ./ trials.del
    sort!(trials, :ins_del)

    plots = [
        @vlplot(:bar, title=path,
                      x={:ins_del, bin={maxbins=30}, title="Sum(cycles to deletion) [binned]"},
                      y={"sum(cycles_to_deletion)", scale={domain=[0, 10000 * 10]}});
        @vlplot(:bar, x={:ins_del, bin={maxbins=30}, title="# trials [binned]"},
                      y={"count()", scale={domain=[0, 10000]}})
    ]

    trials |> plots |> display
    trials
end
