#!/bin/bash

oldDir=$(pwd)

type=$1

design=$2

title=$3

#Get build dir
scriptSrc=$(dirname "${BASH_SOURCE[0]}")
cd "$scriptSrc"
scriptSrc=$(pwd)

cd "$oldDir"

#source the virtual env
source "$scriptSrc/venv/bin/activate"

# Set the partition names

#partNames=("RRC/AGC" "TR (Other)" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Early/Late" "TR Freq Est./Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")
#partNames=("RRC" "AGC" "TR (Other)" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Early/Late" "TR Freq Est./Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")
#partNames=("RRC" "AGC" "TR (Other)" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Early/Late" "TR Freq Est." "TR Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#Version with Partitioned AGC and Repartitioned Timing Recovery
partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "AGC Settled" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late" "TR Freq. Est" "TR Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

# CPU Frequency
cpuFreqGHz=2.0

# Set the relevant paths to plot
if [[ $type == "cyclops"  ]]; then
  configPath=./genSrc/cOut_rev1BB_receiver/rx_demo_telemDump_telemConfig.json
  telemPath=./results/rx
  reportPrefix=./resultsPlotted

  if [[ -z $title ]]; then
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 0.07 --output-file-prefix $reportPrefix --partition-names "${partNames[@]}"
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 140 --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz} --partition-names "${partNames[@]}"
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_block --block-size 64 --ylim 0 4.0 --partition-names "${partNames[@]}"
    #"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_summary --cpu-freq-ghz ${cpuFreqGHz} --summarize-fifos --partition-names "${partNames[@]}" &
  else
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 0.07 --output-file-prefix $reportPrefix --partition-names "${partNames[@]}" --title $title
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 140 --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz} --partition-names "${partNames[@]}" --title $title
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_block --block-size 64 --ylim 0 4.0 --partition-names "${partNames[@]}" --title $title
    #"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_summary --cpu-freq-ghz ${cpuFreqGHz} --summarize-fifos --partition-names "${partNames[@]}" &
  fi

else
  configPath=./genSrc/cOut_${design}/${design}_telemDump_telemConfig.json
  telemPath=./results
  reportPrefix=./resultsPlotted

  if [[ -z $title ]]; then
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 0.04 --output-file-prefix $reportPrefix
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 80 --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz}
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_block --block-size 64 --ylim 0 2.5
  else
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 0.04 --output-file-prefix $reportPrefix --title $title
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --ylim 0 80 --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz} --title $title
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_block --block-size 64 --ylim 0 2.5 --title $title
  fi
fi