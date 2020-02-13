
using CSV, DataFrames, VegaLite


function trial_histogram(path)

    trials = DataFrame(CSV.File(path, header=["energy", "ins", "del", "x", "y", "z"]))
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
