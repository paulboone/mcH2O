using VegaLite
using DataFrames
using LinearAlgebra
import Statistics

function ebyn_graph(edf)

    plots = @vlplot(:line,
                data=edf,
                x={:cycle, title="N", type=:ordinal},
                width=800,
                height=800,
            ) +
            @vlplot(:line,
                y={:value, title="Energy", type=:quantitative},
                color=:variable
            ) +
            @vlplot(mark={:line},
                data=edf[edf.variable .== :gh_vdw, :],
                y={:num_adsorbates, type=:quantitative, title="Num Adsorbates"})

    # @vlplot(mark={type=:line},
    #             data=edf,
    #             x={:cycle, title="N", type="ordinal"},
    #             y={:value, title="Energy", type="quantitative"},
    #             width=800,
    #             height=800,
    #             color={field="variable", type="categorical", legend=true}
    #         )
            #  +
            # @vlplot(,
            #     c
            # )
            #     # color={field="molecule_id", type="ordinal", legend=false,
                # scale={scheme={name="blues", extent=[0.2,1.0], count=num_rows, minOpacity=1.0, maxOpacity=1.0}}},
            #     ) +
            # @vlplot(mark={type=:point, size=100},
            #         data=DataFrame(molecule_id=1:size(probs, 1), y=log10.(diag(probs))),
            #         x=:molecule_id,
            #         y=:y,
            #         fill={field="molecule_id", type="ordinal", scale={scheme={name="blues", extent=[0.2,1.0], count=num_rows, minOpacity=1.0, maxOpacity=1.0}}},
            #         ) +
            # @vlplot(:line,
            #         data=DataFrame(num_molecules=1:size(probs, 1), median=[Statistics.median(log10.(probs[i,1:i])) for i=1:size(probs, 1)]),
            #         x=:num_molecules,
            #         y=:median,
            #         color={value="black"},
            #         size={value=4},
            #         )

    plots |> display
end
