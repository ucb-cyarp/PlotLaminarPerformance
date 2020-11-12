#!/bin/bash

oldDir=$(pwd)

#Get build dir
scriptSrc=$(dirname "${BASH_SOURCE[0]}")
cd "$scriptSrc"
scriptSrc=$(pwd)

cd "$oldDir"

#source the virtual env
source "$scriptSrc/venv/bin/activate"

# Set the partition names

#partNames=("RRC/AGC" "TR (Other)" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Early/Late" "TR Freq Est./Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")
partNames=("RRC" "AGC" "TR (Other)" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Early/Late" "TR Freq Est./Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")
#partNames=("RRC" "AGC" "TR (Other)" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Early/Late" "TR Freq Est." "TR Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

# CPU Frequency
cpuFreqGHz=2.0

# Set the relevant paths to plot
configPath=./genSrc/cOut_rev1BB_receiver/rx_demo_telemDump_telemConfig.json
telemPath=./results/rx
reportPrefix=./resultsPlotted

"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix $reportPrefix --partition-names "${partNames[@]}" &
"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz} --partition-names "${partNames[@]}" &
#"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --output-file-prefix ${reportPrefix}_summary --cpu-freq-ghz ${cpuFreqGHz} --summarize-fifos --partition-names "${partNames[@]}" &
