#!/usr/bin/env python3
import click
import matplotlib.pyplot as plt
import pandas as pd

@click.command()
@click.argument('input_file', type=click.File())
@click.argument('output_path', type=click.Path())
@click.option('--pm/--raspa', default=False)
def plot_cycles_csv(input_file, output_path, pm=False):

    if pm:
        ads_df = pd.read_csv(input_file, sep="\t")
        ads_df["total_cycles"] = ads_df.cycle
    else:
        ads_df = pd.read_csv(input_file, names=["total_cycles", "cycles", "cycle_type", "num_adsorbants"])
        ads_df.rename(columns={'num_adsorbants': 'num_adsorbates',}, inplace=True)

    fig = plt.figure(figsize=(7,7))
    ax = fig.add_subplot(1, 1, 1)
    ax.plot(ads_df.total_cycles, ads_df.num_adsorbates, zorder=2)
    ax.set_xlabel('Total Cycles')
    ax.set_ylabel('# Adsorbates')
    ax.set_ylim(bottom=0)
    ax.grid(linestyle='-', color='0.7', zorder=0)
    fig.savefig(output_path, dpi=300)


if __name__ == '__main__':
    plot_cycles_csv()
