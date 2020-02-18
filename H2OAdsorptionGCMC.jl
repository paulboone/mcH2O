

using PorousMaterials
include("ProbsGraph.jl")

function trial_probability_model(molecule_name, pressure_pa, max_trials)

    framework = Framework("ZIF-8q.cif")
    strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

    forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
    molecule = Molecule(molecule_name)

    temperature = 298.0 # K
    pressure = pressure_pa / 100000 # bar

    # conduct grand-canonical Monte Carlo simulation
    gcmc_trials(framework, molecule, temperature, pressure, forcefield,
                max_adsorbates=100, max_trials=max_trials)

end

# molecule_name = "H2O_tip4p"
molecule_name = "CO2"
pressure_pa = 4500.0
max_trials = 1000


trial_probability_model(molecule_name, pressure_pa, max_trials)
df = DataFrame(CSV.File("inserted_adsorbates_$(molecule_name)_$(pressure_pa)_$(max_trials).csv", header=["molecule_#", "E_gh_vdw","E_gh_q", "E_gg_vdw", "E_gg_q", "ins", "ins_empty", "ins_empty2", "ins_full","x", "y", "z"]))


df.E_gg = df.E_gg_vdw + df.E_gg_q
df.E_gh = df.E_gh_vdw + df.E_gh_q
df.E = df.E_gg + df.E_gh
adsorbates = df[:, Not([:x, :y, :z])]

probs = readdlm("adsorbate_prob_by_molecule_num_$(molecule_name)_$(pressure_pa)_$(max_trials).csv", '\t', Float64, '\n')
# DataFrame(CSV.File("adsorbate_prob_by_molecule_num_H2O_tip4p.csv", header=false))

adsorbates, probs
