#!/usr/bin/env python3
from glob import glob
import re

import click
import matplotlib.pyplot as plt
import pandas as pd

@click.command()
@click.argument('input_glob', type=click.STRING)
@click.option('--output-path', '-o', type=click.Path())
def isotherm_csv(input_glob, output_path):
    num_from_filename = lambda x:int(re.findall("(\d+)",x)[0])

    sorted_input_glob = sorted(glob(input_glob), key=num_from_filename)

    num_adsorbed = [pd.read_csv(fn, names=[1,2,3,'num']).num.iloc[-1] for fn in sorted_input_glob]
    pressure = [num_from_filename(path) for path in sorted_input_glob]
    df = pd.DataFrame(data=dict(pressure=pressure, num_adsorbed=num_adsorbed))
    df.to_csv(output_path)

@click.command()
@click.argument('input_csv', type=click.File('r'))
@click.option('--output-path', '-o', type=click.Path())
def isotherm_plot(input_csv, output_path):
    df = pd.read_csv(input_csv)
    fig = plt.figure(figsize=(7,7))
    ax = fig.add_subplot(1, 1, 1)
    ax.plot(df.pressure, df.num_adsorbed, zorder=2)
    ax.set_xlabel('Pressures')
    ax.set_ylabel('# Adsorbants')
    ax.set_ylim(bottom=0)
    ax.set_xlim([0, 4500])
    ax.grid(linestyle='-', color='0.7', zorder=0)
    fig.savefig(output_path, dpi=300)


if __name__ == '__main__':
    isotherm_plot()
