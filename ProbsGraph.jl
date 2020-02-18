using VegaLite
using DataFrames
using LinearAlgebra
import Statistics

function probs_graph(probs)
    num_rows = *(size(probs)...)

    plots = @vlplot(
                data=DataFrame(
                        num_molecules=[(i - 1) % size(probs,1) + 1 for i = 1:num_rows],
                        molecule_id=[(i - 1) ÷ size(probs,1) + 1 for i = 1:num_rows],
                        prob=log10.(replace(vec(probs), 0.0=>NaN))
                    ),
                x={"num_molecules", title="Molecule insert #", type="quantitative"},
                y={"prob", title="log(insert probability)", type="quantitative", scale={domain=[-2.0, 8.0]}},
                opacity={value=1},
                width=800,
                height=800
            ) +
            @vlplot(mark={type=:line},
                color={field="molecule_id", type="ordinal", legend=false,
                    scale={scheme={name="blues", extent=[0.2,1.0], count=num_rows, minOpacity=1.0, maxOpacity=1.0}}},
                    ) +
            @vlplot(mark={type=:point, size=100},
                    data=DataFrame(molecule_id=1:size(probs, 1), y=log10.(diag(probs))),
                    x=:molecule_id,
                    y=:y,
                    fill={field="molecule_id", type="ordinal", scale={scheme={name="blues", extent=[0.2,1.0], count=num_rows, minOpacity=1.0, maxOpacity=1.0}}},
                    ) +
            @vlplot(:line,
                    data=DataFrame(num_molecules=1:size(probs, 1), median=[Statistics.median(log10.(probs[i,1:i])) for i=1:size(probs, 1)]),
                    x=:num_molecules,
                    y=:median,
                    color={value="black"},
                    size={value=4},
                    )

    plots |> display
end
