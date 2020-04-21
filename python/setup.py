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
              'h2o-rasparestart-split-dimer = h2ohelp.restart_split_dimer:restart_split_dimer',
              'h2o-split-xyz = h2ohelp.split_xyz:split_xyz',
              'h2o-isotherm-csv = h2ohelp.isotherm:isotherm_csv',
              'h2o-isotherm-plot = h2ohelp.isotherm:isotherm_plot'
          ]
      },
)
