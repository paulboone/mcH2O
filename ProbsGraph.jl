using VegaLite
using DataFrames
using LinearAlgebra

function probs_graph(probs)
    num_rows = *(size(probs)...)
    df = DataFrame(
            num_molecules=[(i - 1) % size(probs,1) + 1 for i = 1:num_rows],
            molecule_id=[(i - 1) ÷ size(probs,1) + 1 for i = 1:num_rows],
            prob=log10.(replace(vec(probs), 0.0=>NaN))
        )

    println(df[:, :molecule_id])
    plots = @vlplot(
                data=df,
                x={"num_molecules", title="Molecule insert #"},
                y={"prob", title="log(insert probability)"},
                color="molecule_id:o",
                width=1200,
                height=1200
            ) +
            @vlplot(mark=({type=:line, point=true})) +
            # @vlplot(mark={type=:text, dy=-7},
            #         text={field=:molecule_id, type=:ordinal}
            #         ) +
            @vlplot(mark={type=:point, size=100, alpha=1.0},
                    data=DataFrame(molecule_id=1:39, y=log10.(diag(probs))),
                    x=:molecule_id,
                    y=:y,
                    color="molecule_id:o",
                    # fill="molecule_id:o",

                    )




                    # text={field=:molecule_id, type=:ordinal},
                    # text={field=:molecule_id, type=:nominal},
                    # )
            #         +
            # @vlplot(mark=:line,
            #
            #         )
            #
            # plots = @vlplot(mark={:line, point=true, :text=true},
            #                 enc={
            #                     x={"num_molecules:o", title="Molecule insert #"},
            #                     y={"prob:q", title="log(insert probability)"},
            #                     color=:molecule_id
            #                 },
            #                 title="asdf",
            #                 width=1200,
            #                 height=1200
            #
            #                 # text={field=:molecule_id, type=:ordinal},
            #                 # text={field=:molecule_id, type=:nominal},
            #                 )


    plots |> display
    # df |> plots |> display
end
