#!/bin/bash

oldDir=$(pwd)

design=$1

#Get build dir
scriptSrc=$(dirname "${BASH_SOURCE[0]}")
cd "$scriptSrc"
scriptSrc=$(pwd)

cd "$oldDir"

#source the virtual env
source "$scriptSrc/venv/bin/activate"

# Set the relevant paths to plot
if [[ -z $design  ]]; then
  configPath=./genSrc/cOut_rev1BB_receiver/rx_demo_telemDump_telemConfig.json
  telemPath=./results/rx
else
  configPath=./genSrc/cOut_${design}/${design}_telemDump_telemConfig.json
  telemPath=./results
fi

echo "$scriptSrc/reportCapturedSamples.py --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry"
"$scriptSrc/reportCapturedSamples.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry
