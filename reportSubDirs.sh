#!/bin/bash

plottingScript="$HOME/PycharmProjects/PlotLaminarPerformance/reportThisDir.sh"

type=$1 #cyclops or nothing

origDir=$(pwd)

dirsToPlot=$(ls)
for dir in $dirsToPlot
do
  fullPath="$origDir/$dir"

  #Check if it is a dir
  if [[ -d $fullPath ]]; then
    cd "$fullPath" || exit

    #Get design name
    genSrcDirs=$(ls -1 genSrc)

    for genSrcDir in $genSrcDirs
    do
      #Strip off cOut_
      #See https://stackoverflow.com/questions/9597751/using-match-to-find-substrings-in-strings-with-only-bash
      #for some explanation of the bash regex operator
      if [[ $genSrcDir =~ cOut_(.*) ]]; then
        designName=${BASH_REMATCH[1]}

        #Plot
        echo "In $fullPath:"
        echo "Executing: $plottingScript $designName $dir"

        if [[ $type == "cyclops" ]]; then
          $plottingScript
        else
          $plottingScript "$designName"
        fi
      fi
    done
  fi
done

cd "$origDir" || exit