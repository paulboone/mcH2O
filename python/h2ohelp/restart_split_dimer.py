#!/usr/bin/env python3
import re

import click

@click.command()
@click.argument('restart_file', type=click.File())
def restart_split_dimer(restart_file):
    """
    Splits a RASPA restart file.
"""
    comp1_re = r"(Components: 1 \(Adsorbates )(\d+)(, Cations 0\))"
    comp2_re = r"(Component: 0     Adsorbate    )(\d+)( molecules of )TIP4P-2"

    # line_idx =  0
    reached_fields = False
    for line in restart_file:
        # line_idx += 1
        # if line_idx > 100:
        #     break

        if not reached_fields:
            if (match := re.match(comp1_re, line)):
                prefix, adsorbates, suffix = match.groups()
                adsorbates = int(adsorbates) * 2
                print(prefix + str(adsorbates) + suffix)
            elif (match := re.match(comp2_re, line)):
                prefix, adsorbates, suffix = match.groups()
                adsorbates = int(adsorbates) * 2
                print(prefix + str(adsorbates) + suffix + "TIP4P-1")
                pass
            elif "Lambda-factors component 0" in line:
                print("\tLambda-factors component 0:  0.000000 0.000000 0.000000 0.000000")
            elif "TIP4P-2" in line:
                print(line.replace("TIP4P-2", "TIP4P-1"))
            else:
                print(line, end="")

            if line.startswith("----"):
                reached_fields = True
            continue

        if line.strip() == "":
            break

        label, fieldstr = line.split(":")
        fields = fieldstr.split()
        molecule_id = int(fields[0])
        atom_id = int(fields[1])
        values = fields[2:]

        # calculate new molecule_id and atom_id for split H2O
        split_molecule_id = molecule_id * 2 + atom_id // 4
        split_atom_id = atom_id % 4

        # don't print forces or velocities since they are definitely invalid
        if label not in ["Adsorbate-atom-force", "Adsorbate-atom-velocity"]:
            print("%s: %d %d %s" % (label, split_molecule_id, split_atom_id, " ".join(values)))

if __name__ == '__main__':
    restart_split_dimer()
