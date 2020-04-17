#!/usr/bin/env python3
import click

@click.command()
@click.argument('restart_path', type=click.Path())
def split_restart_dimer(restart_path):

    with open(restart_path, "r") as f:
        # line_idx =  0

        # labels = set([line.split(":")[0] for line in f])
        reached_fields = False

        for line in f:
            # line_idx += 1
            # if line_idx > 100:
            #     break

            if not reached_fields:
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
    split_restart_dimer()
