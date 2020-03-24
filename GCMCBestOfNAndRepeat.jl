using VegaLite
using DataFrames
using LinearAlgebra
import Statistics

using PorousMaterials

function gcmc_bestofNandrepeat_plot(probs)
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


"""
    mol_probs = gcmc_bestofNandrepeat_data(molecule_name, pressure_pa, max_trials; molecule_multiplier=1)

Helper that runs a GCMC best-of-N-trials-and-repeat for ZIF-8 with all our default settings
(Dreiding, 298K) and returns molecule_probs of each insert. A GCMC best-of-N-trials-and-repeat is
when you take N trial insertions, take the best insertion (with the lowest ∆E) and if the insertion
probability is >= 1.0 (i.e. 100% chance of insertion), then insert it; repeat until we get a round
where all N trials have insertion probability < 1.0. Returns the molecule probabilities for plotting
with `gcmc_bestofNandrepeat_plot`.
"""
function gcmc_bestofNandrepeat_data(molecule_name, pressure_pa, max_trials; molecule_multiplier=1)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar

    # conduct grand-canonical Monte Carlo simulation
    return gcmc_bestofNandrepeat(framework, molecule, temperature, pressure, forcefield,
                max_adsorbates=100, max_trials=max_trials)

end
