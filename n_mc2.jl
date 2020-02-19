using PorousMaterials

framework = Framework(framework_name)
strip_numbers_from_atom_labels!(framework) # remove annoying numbers from atom labels

forcefield = LJForceField("Dreiding.csv", cutoffradius=12.8)
molecule = Molecule(molecule_name)

pressure = pressure_pa / 100000 # bar

# conduct grand-canonical Monte Carlo simulation
results, molecules = gcmc_simulation(framework, molecule, temperature, pressure, forcefield; args...)
