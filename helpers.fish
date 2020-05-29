# source helpers.fish

function h2o-outputs2csvs
    for d in $argv
        for o in $d/Output/*/*.data
            set outputcsv $d\__(basename $o).csv
            echo $outputcsv
            h2o-raspa2cyclescsv $o > $outputcsv
        end
    end
end

function h2o-h2poutputs2csvs
    for d in $argv
      set outputcsv $d.csv
      echo $outputcsv
      cat $d/results*/Output/*/*.data | h2o-raspa2cyclescsv - >> $outputcsv
    end
end

function h2o-csvs2plots
    for d in $argv
        echo outputting $d.png
        h2o-plot-cycles-csv $d $d.png
    end
end

function setup-sim-dirs-for-pressures
  set template_path $argv[1]
  set pressures $argv[2..-1]

  for p in $pressures
    cp -R $template_path ./P$p
    gsed -i -e "s|^ExternalPressure.*|ExternalPressure     $p|" ./P$p/*.input
  end
end


function setup-sim-dirs-for-pressures-pm
  set template_path $argv[1]
  set pressures $argv[2..-1]

  for p in $pressures
    cp -R $template_path ./P$p
    gsed -i -e "s|^pressure_pa.*|pressure_pa = $p|" ./P$p/run.jl
  end
end
# first arg is path to .slurm file, next N args are paths to .input files. Typically used from
# directory containing sim dirs:
#   sbatch-all ./raspa.slurm P*/h2o_dimer.input
function sbatch-all
	echo (count $argv)
  set slurm_path (realpath $argv[1])
  for d in $argv[2..-1]
    set jobname (basename (dirname (dirname (realpath $d))))/(basename (dirname (realpath $d)))
    cd (dirname $d)
    sbatch -J $jobname < $slurm_path
    cd ..
  end
end

function h2o-move-results-up
  for d in $argv
    mv $d/results/* $d/
  end
end


# function h2o-setup-cycles
#   set cycles $argv[1]
#   set initcycles $argv[2]
#   set setupfiles $argv[3..-1]
#
#   gsed -i -e "s|^RestartFile.*|RestartFile  yes|" $setuppath
#   gsed -i -e "s|^Cycles.*|Cycles  $cycles|" $setuppath
#   gsed -i -e "s|^InitializationCycles.*|InitializationCycles  $initcycles|" $setuppath
# end




function h2o-restart
  set cycles $argv[1]
  set initcycles $argv[2]
  set setupfiles $argv[3..-1]

  for setuppath in $setupfiles
    set simdir (dirname $setuppath)
    set restartnum (math (ls -l $setuppath* | wc -l) - 1)

    # archive existing .setup file
    cp $setuppath $setuppath.$restartnum

    # modify .setup file
    gsed -i -e "s|^RestartFile.*|RestartFile  yes|" $setuppath
    gsed -i -e "s|^NumberOfCycles.*|NumberOfCycles  $cycles|" $setuppath
    gsed -i -e "s|^NumberOfInitializationCycles.*|NumberOfInitializationCycles  $initcycles|" $setuppath

    # archive results dir
    if test -d $simdir/results
      mv $simdir/results $simdir/results.$restartnum
    end

    # archive existing RestartInitial dir
    if test -d $simdir/RestartInitial
      mv $simdir/RestartInitial $simdir/RestartInitial.$restartnum
    end

    # copy most recent Restart dir
    cp -R $simdir/results.$restartnum/Restart $simdir/RestartInitial

    # archive raspa log
    mv $simdir/raspajob.log $simdir/raspajob.log.$restartnum
  end
end


function h2o-cleanup-dimers
  set setupfiles $argv

  for setuppath in $setupfiles
    set simdir (dirname $setuppath)
    set restartnum (math (ls -l $setuppath* | wc -l) - 1)

    # archive existing .setup file
    cp $setuppath $setuppath.$restartnum

    # archive results dir
    if test -d $simdir/results
      mv $simdir/results $simdir/results.$restartnum
    end

    mkdir -p $simdir/dimer-results
    if test (count $simdir/results*) -gt 0
      mv $simdir/results* $simdir/dimer-results/
    end
    if test (count $simdir/raspajob.log*) -gt 0
      mv $simdir/raspajob.log* $simdir/dimer-results/
    end
    # remove existing RestartInitial dir
    if test -d $simdir/RestartInitial
      rm -rf $simdir/RestartInitial
    end
  end
end

function h2o-split-restart
  set setupfiles $argv

  for setuppath in $setupfiles
    set simdir (dirname $setuppath)
    set restartnum (math (ls -d $simdir/dimer-results/results* | wc -l) - 1)

    # split dimers to singles
    mkdir -p $simdir/RestartInitial/System_0/
    set restart_file (ls $simdir/dimer-results/results.$restartnum/Restart/System_0/)
    set dimer_restart_file_in $simdir/dimer-results/results.$restartnum/Restart/System_0/$restart_file
    set single_restart_file_out $simdir/RestartInitial/System_0/$restart_file

    h2o-rasparestart-split-dimer $dimer_restart_file_in > $single_restart_file_out
  end
end
