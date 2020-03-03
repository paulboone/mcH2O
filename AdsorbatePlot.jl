

using CSV
using DataFrames
using Glob
using Plots


searchglob = "h2o_N*/energy*.tsv"

p = plot(legend=:bottomright, xlim=(0,100_000))
for adscsv in glob(searchglob)
    sizeN, xmult = parse.(Int64, match(r".+_N(\d*)_x(\d*).+", adscsv).captures)

    df = CSV.File(adscsv) |> DataFrame
    plot!(p, df.cycle, df.num_adsorbates * sizeN, label="H2O N$(sizeN) x$(xmult)")
end

p
