#!/usr/bin/env python

from distutils.core import setup
setup(
    name = 'h2ohelp',
    version = '0.1.0',
    description = 'Helper scripts for RASPA and runing H2O simulations',
    author = 'Paul Boone',
    author_email = 'paulboone@pitt.edu',
    url = 'https://github.com/paulboone//mcH2O',
    packages = ['h2ohelp'],
    install_requires=[
        'click',
        'pandas',
        'matplotlib',
    ],
    entry_points={
          'console_scripts': [
              'h2o-raspa2cyclescsv = h2ohelp.raspa2cyclescsv:raspa2cyclescsv',
              'h2o-plot-cycles-csv = h2ohelp.plot_cycles_csv:plot_cycles_csv',
              'h2o-rasparestart-split-dimer = h2ohelp.split_restart_dimer:split_restart_dimer',
              'h2o-splix-xyz = h2ohelp.split_xyz:split_xyz',

          ]
      },
)
