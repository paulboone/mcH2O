#!/usr/bin/env python3
import click
import matplotlib.pyplot as plt
import pandas as pd

@click.command()
@click.argument('input_file', type=click.File())
@click.argument('output_path', type=click.Path())
def plot_cycles_csv(input_file, output_path):
    ads_df = pd.read_csv(input_file, names=["total_cycles", "cycles", "cycle_type", "num_adsorbants"])

    fig = plt.figure(figsize=(7,7))
    ax = fig.add_subplot(1, 1, 1)
    ax.plot(ads_df.total_cycles, ads_df.num_adsorbants, zorder=2)
    ax.set_xlabel('Total Cycles')
    ax.set_ylabel('# Adsorbants')
    ax.grid(linestyle='-', color='0.7', zorder=0)
    fig.savefig(output_path, dpi=300)


if __name__ == '__main__':
    plot_cycles_csv()
