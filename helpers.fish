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

function h2o-csvs2plots
    for d in $argv
        echo outputting $d.png
        h2o-plot-cycles-csv $d $d.png
    end
end
