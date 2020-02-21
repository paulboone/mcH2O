using CSV, DataFrames, Plots
import Plots.PlotMeasures: px


e_df_batch = CSV.File("h2o_4500_mc_n1000_batch/energy_log_H2O_tip4p_4500.0_n1000_batch.tsv") |> DataFrame
e_df_batch.e_total = e_df_batch.gh_vdw .+ e_df_batch.gh_q .+ e_df_batch.gg_vdw .+ e_df_batch.gg_q
e_df_baseline = CSV.File("h2o_4500_mc_n1000_baseline/energy_log_H2O_tip4p_4500.0_n1000_baseline.tsv") |> DataFrame
e_df_baseline.e_total = e_df_baseline.gh_vdw .+ e_df_baseline.gh_q .+ e_df_baseline.gg_vdw .+ e_df_baseline.gg_q

function eplots(e_df, ebounds, nbounds; legend=false, y_formatter=:plain, noylabel=false, title="")
  ylabel = noylabel ? "" : "Energy [K] / 1000"
  leftmargin = noylabel ? 0px : 40px
  eplot = plot(e_df.cycle, e_df.gh_vdw / 1000, label="Guest-host VDW",
            xlims = 0:404_000, xticks= 0:40_000:404_000, xlabel="MC Move Index",
            ylabel=ylabel, ylims=ebounds,
            minorticks=10, minorgrid=true, x_formatter=:plain, legend=legend,
            y_formatter=y_formatter, top_margin=0px, left_margin=leftmargin,
            bottom_margin=20px)
  hline!(eplot, [0], lc="grey", lw=2, label="")

  plot!(eplot, e_df.cycle, e_df.gh_q / 1000, label="Guest-host Coulomb")
  plot!(eplot, e_df.cycle, e_df.gg_vdw / 1000, label="Guest-guest VDW")
  plot!(eplot, e_df.cycle, e_df.gg_q / 1000, label="Guest-guest Coulomb")
  plot!(eplot, e_df.cycle, e_df.e_total / 1000, label="Total")

  ylabel = noylabel ? "" : "# H2O"
  nplot = plot(e_df.cycle, e_df.num_adsorbates, label="",
            xlims = 0:404_000, xticks= 0:40_000:404_000, xformatter=_->"",
            ylabel=ylabel, ylims=nbounds, bottom_margin=0px, y_minorticks=3,
            x_minorticks=10, minorgrid=true, y_formatter=y_formatter, title=title,
            left_margin=leftmargin)

  return eplot, nplot
end

ebounds = (minimum(describe(e_df_batch[:, 3:6])[:, :min]), maximum(describe(e_df_batch[:, 3:6])[:, :max])) ./ 1000
nbounds = (0, maximum(e_df_batch[:, :num_adsorbates]))

batche, batchn = eplots(e_df_batch, ebounds, nbounds, legend=false, title="Batch Method")
baselinee, baselinen = eplots(e_df_baseline, ebounds, nbounds, legend=:bottomright,
    y_formatter=_->"", noylabel=true, title="Baseline Method")

master_plot = plot(batchn, baselinen, batche, baselinee, size=(1200,800), dpi=300, layout=grid(2,2,heights=[0.25,0.75]))
master_plot
# plot!(twinx(), e_df.num_adsorbates, label="Num adsorbates")
# hline!(0, lc="grey", lw=3)
