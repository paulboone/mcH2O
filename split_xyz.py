import os

# import click

def split_xyz(xyzpath, out_dir):
    idx = 0
    with open(xyzpath, "r") as f:
        line = next(f)
        while (line):
            idx += 1
            print(idx)

            i = int(line.strip())
            if i > 0:
                with open(os.path.join(out_dir, "%d.xyz" % idx), "w") as xyz_outfile:
                    xyz_outfile.write(line)
                    line = next(f)
                    if line.strip() == "":
                        line = "split xyz"
                    xyz_outfile.write(line + "\n")
                    for _ in range(1, (i + 1)):
                        xyz_outfile.write(next(f).replace("O_h2o", "O"))
            else:
                try:
                    next(f)
                except StopIteration:
                    break

            try:
                line = next(f)
            except StopIteration:
                break

split_xyz("gcmc_ZIF-8q_H2O_tip4p_T298.000000_P0.045000_Dreiding_4burn_400sample_adsorbate_positions_batch.xyz", "xyzout_batch")
