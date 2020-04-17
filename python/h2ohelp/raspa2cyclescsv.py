#!/usr/bin/env python3
import csv
import re
import sys

import click

@click.command()
@click.argument('path', type=click.Path())
def raspa2cyclescsv(path):
    with open(path, 'r') as f:
        csvout = csv.writer(sys.stdout)
        # go to start of simulation
        while next(f).strip() != "Starting simulation": pass

        cycle_re = r"(\[Init\] )*Current cycle: (\d+) out of \d+"
        adsorbates_re = r"Number of Adsorbates: +(\d+) \((\d+) integer, (\d+) fractional, (\d+) reaction\)"

        on_init_cycles = True
        cycle_diff = 0
        cycles_1_2 = []
        cycle_index = 0

        try:
            while True:
                # find next cycle
                while (match := re.match(cycle_re, next(f).strip())) == None: pass

                cycle_kind = match.groups()[0].strip() if match.groups()[0] is not None else ""
                cycle_num = int(match.groups()[1])

                # warning: automatically recognizing the cycles frequency requires at least TWO outputs
                if cycle_diff == 0:
                    cycles_1_2.append(cycle_num)
                    if len(cycles_1_2) == 2:
                        cycle_diff = cycles_1_2[1] - cycles_1_2[0]

                if cycle_diff > 0:
                    total_cycles = cycle_index * cycle_diff
                else:
                    total_cycles = cycle_num

                # find next # adsorbants
                while (match := re.match(adsorbates_re, next(f).strip())) == None: pass
                num_adsorbates = int(match.groups()[0])

                # output csv line
                csvout.writerow([total_cycles, cycle_num, cycle_kind, num_adsorbates])

                cycle_index += 1
        except StopIteration:
            pass

if __name__ == '__main__':
    raspa2cyclescsv()
