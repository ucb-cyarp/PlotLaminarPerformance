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
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "AGC Settled" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late" "TR Freq. Est" "TR Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#Version without AGC Settle Calculation
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late" "TR Freq. Est" "TR Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#1Part
#partNames=("All")
#2 Parts
#partNames=("Sample Domain" "Symbol Domain")
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay, TR Golay Corr., TR Golay Peak, TR Control" "TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum, Coarse CFO, EQ, CFO/Demod/Hdr Parse, Data Packer, Pkt. & Freeze Ctrl")
#3 Parts
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay, TR Golay Corr." "TR Golay Peak, TR Control, TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum" "Coarse CFO, EQ, CFO/Demod/Hdr Parse, Data Packer, Pkt. & Freeze Ctrl")
#4 Parts
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay" "TR Golay Corr., TR Golay Peak, TR Control, TR Symbol Clk." "TR Early/Late, TR Freq. Est, TR Delay Accum, Coarse CFO, Pkt. & Freeze Ctrl" "EQ, CFO/Demod/Hdr Parse, Data Packer")
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay" "TR Golay Corr., TR Golay Peak, TR Control" "TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum, Coarse CFO, Pkt. & Freeze Ctrl" "EQ, CFO/Demod/Hdr Parse, Data Packer")

#Split Var Delay
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay Pt1" "TR Var. Delay Pt2" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late" "TR Freq. Est" "TR Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#3Parts Split5_12
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay" "TR Golay Corr., TR Golay Peak, TR Control, TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum" "Coarse CFO, EQ, CFO/Demod/Hdr Parse, Data Packer, Pkt. & Freeze Ctrl")

#4 Parts Split 5, 8, 13.16
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay" "TR Golay Corr., TR Golay Peak, TR Control" "TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum, Coarse CFO, Pkt. & Freeze Ctrl" "EQ, CFO/Demod/Hdr Parse, Data Packer")
#4 Parts Split 4, 8, 13.16
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay Pt1" "TR Var. Delay Pt2, TR Golay Corr., TR Golay Peak, TR Control" "TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum, Coarse CFO, Pkt. & Freeze Ctrl" "EQ, CFO/Demod/Hdr Parse, Data Packer")
#5 Parts Split 3, 6, 9, 13.16
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop" "TR Var. Delay, TR Golay Corr." "TR Golay Peak, TR Control, TR Symbol Clk." "TR Early/Late, TR Freq. Est, TR Delay Accum, Coarse CFO, Pkt. & Freeze Ctrl" "EQ, CFO/Demod/Hdr Parse, Data Packer")
#4 Parts Split 4, 7, 12.16
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay Pt1" "TR Var. Delay Pt2, TR Golay Corr., TR Golay Peak" "TR Control, TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum, Pkt. & Freeze Ctrl" "Coarse CFO, EQ, CFO/Demod/Hdr Parse, Data Packer")
#5 Parts Split 4, 7, 12, 14.16
#partNames=("RRC, AGC Pwr. Avg., AGC Correct. Loop, TR Var. Delay Pt1" "TR Var. Delay Pt2, TR Golay Corr., TR Golay Peak" "TR Control, TR Symbol Clk., TR Early/Late, TR Freq. Est, TR Delay Accum" "Coarse CFO, EQ, Pkt. & Freeze Ctrl" "CFO/Demod/Hdr Parse, Data Packer")


#Version with TR Freq Est and TR Delay Accum Combined
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late" "TR Freq. Est & Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#Version with TR Early/Late TR Freq Est and TR Delay Accum Combined
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late, Freq. Est, Delay Accum" "Coarse CFO" "EQ" "CFO/Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#Version with TR Early/Late TR Freq Est and TR Delay Accum Combined, Split Symbol Domain With FSM Isolated
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late, Freq. Est, Delay Accum" "Coarse CFO" "EQ" "CFO/Demod" "Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#Version with TR Early/Late TR Freq Est and TR Delay Accum Combined, Split Symbol Domain With FSM Combined with Demod
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late, Freq. Est, Delay Accum" "Coarse CFO" "EQ" "CFO" "Demod/Hdr Parse" "Data Packer" "Pkt. & Freeze Ctrl")

#Version with TR Early/Late TR Freq Est and TR Delay Accum Combined, Reogrganized Header Parse, Split Symbol Domain With FSM Isolated
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late, Freq. Est, Delay Accum" "Coarse CFO" "EQ" "Hdr Parse" "CFO/Demod" "Data Packer" "Pkt. & Freeze Ctrl")

#Version with TR Early/Late TR Freq Est and TR Delay Accum Combined, Reogrganized Header Parse, Split Symbol Domain 3 Way
#partNames=("RRC" "AGC Pwr. Avg." "AGC Correct. Loop" "TR Var. Delay" "TR Golay Corr." "TR Golay Peak" "TR Control" "TR Symbol Clk." "TR Early/Late, Freq. Est, Delay Accum" "Coarse CFO" "EQ" "Hdr Parse" "CFO" "Demod" "Data Packer" "Pkt. & Freeze Ctrl")

#Coarse/Fine TR With Fine Grain Partitioning
#partNames=("RRC"  # RxRRCPartition = 1;
#           "AGC"       # RxAGCPwrAvgPartition = 2;
#                  # RxAGCCorrectionLoopPartition = 2;
#           "TR Golay Corr"       # RxTimingRecoveryGolayCorrelatorPartition = 3;
#           "TR Golay Peak"       # RxTimingRecoveryGolayPeakDetectPartition = 4;
#           "TR Control"      # RxTimingRecoveryControlPartition = 5;
#           "TR Error Calc & Freq Est"       # RxTimingRecoveryCalcDelayError = 6;
#                  # RxTimingRecoveryFreqEstPartition = 6;
#           "TR Delay Accum"       # RxTimingRecoveryDelayAccumPartition = 7;
#           "TR Var Delay & Symb Clk"       # RxTimingRecoveryVariableDelayPartition = 8;
#                  # RxTimingRecoverySymbolClockPartition = 8;
#           "TR Early/Late"       # RxTimingRecoveryEarlyLatePartition = 9;
#           "Symb Golay Corr"       # RxSymbGolayCorrelatorPartition = 10;
#           "Symb Golay Peak"       # RxSymbGolayPeakDetectPartition = 11;
#           "Coarse CFO"       # RxCoarseCFOPartition = 12;
#           "EQ"       # RxEQPartition = 13;
#           "Fine CFO"       # RxFineCFOPartition = 14;
#           "Demod"       # RxDemodPartition = 15;
#           "Hdr Demod"      # RxHeaderDemodPartition = 16;
#           "Hdr Parse"       # RxHeaderParsePartition = 17;
#           "Packer"       # RxPackerPartition = 18;
#           "Pkt Control"       # RxPacketControllerPartition = 19;
#                  # RxFreezeControllerPartition = 19;
#           )

#Coarse/Fine TR Repartitioned
#partNames=("RRC"  # RxRRCPartition = 1;
#           "AGC"       # RxAGCPwrAvgPartition = 2;
#                  # RxAGCCorrectionLoopPartition = 2;
#           "TR Golay Corr"       # RxTimingRecoveryGolayCorrelatorPartition = 3;
#           "TR Golay Peak"       # RxTimingRecoveryGolayPeakDetectPartition = 4;
#           "TR Control"      # RxTimingRecoveryControlPartition = 5;
#           "TR Error Calc & Freq Est & Delay Accum"       # RxTimingRecoveryCalcDelayError = 6;
#                  # RxTimingRecoveryFreqEstPartition = 6;
#                  # RxTimingRecoveryDelayAccumPartition = 6;
#           "TR Var Delay"       # RxTimingRecoveryVariableDelayPartition = 7;
#           "TR Symb Clk"       # RxTimingRecoverySymbolClockPartition = 8;
#           "TR Early/Late"       # RxTimingRecoveryEarlyLatePartition = 9;
#           "Symb Golay Corr & Peak"       # RxSymbGolayCorrelatorPartition = 10;
#                  # RxSymbGolayPeakDetectPartition = 10;
#           "Coarse CFO"       # RxCoarseCFOPartition = 11;
#           "EQ"       # RxEQPartition = 12;
#           "Fine CFO"       # RxFineCFOPartition = 13;
#           "Hdr Demod & Parse"      # RxHeaderDemodPartition = 14;
#                  # RxHeaderParsePartition = 14;
#           "Demod & Packer"       # RxDemodPartition = 15;
#                  # RxPackerPartition = 15;
#           "Pkt Control"       # RxPacketControllerPartition = 16;
#                  # RxFreezeControllerPartition = 16;
#           )

#Coarse/Fine TR Repartitioned, Split Fine CFO
#partNames=("RRC"  # RxRRCPartition = 1;
#           "AGC"       # RxAGCPwrAvgPartition = 2;
#                  # RxAGCCorrectionLoopPartition = 2;
#           "TR Golay Corr"       # RxTimingRecoveryGolayCorrelatorPartition = 3;
#           "TR Golay Peak"       # RxTimingRecoveryGolayPeakDetectPartition = 4;
#           "TR Control"      # RxTimingRecoveryControlPartition = 5;
#           "TR Error Calc & Freq Est & Delay Accum"       # RxTimingRecoveryCalcDelayError = 6;
#                  # RxTimingRecoveryFreqEstPartition = 6;
#                  # RxTimingRecoveryDelayAccumPartition = 6;
#           "TR Var Delay"       # RxTimingRecoveryVariableDelayPartition = 7;
#           "TR Symb Clk"       # RxTimingRecoverySymbolClockPartition = 8;
#           "TR Early/Late"       # RxTimingRecoveryEarlyLatePartition = 9;
#           "Symb Golay Corr & Peak"       # RxSymbGolayCorrelatorPartition = 10;
#                  # RxSymbGolayPeakDetectPartition = 10;
#           "Coarse CFO"       # RxCoarseCFOPartition = 11;
#           "EQ"       # RxEQPartition = 12;
#           "Fine CFO"       # RxFineCFOPartition = 13;
#           "Fine CFO Correct"       # RxFineCFOPartition = 14;
#           "Hdr Demod & Parse"      # RxHeaderDemodPartition = 15;
#                  # RxHeaderParsePartition = 15;
#           "Demod & Packer"       # RxDemodPartition = 16;
#                  # RxPackerPartition = 16;
#           "Pkt Control"       # RxPacketControllerPartition = 17;
#                  # RxFreezeControllerPartition = 17;
#           )

##Rev 1.4 Block LMS Manually Unrolled
#partNames=(
#"RRC"                                    #VITIS_PARTITION directive of 1 under RootRaisedCosine
#"AGC"                                    #VITIS_PARTITION directive of 2 under AGC/AGCPwrAvg
#                                         #VITIS_PARTITION directive of 2 under AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under Subsystem
#"TR Golay Corr"                          #VITIS_PARTITION directive of 3 under TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#"TR Golay Peak"                          #VITIS_PARTITION directive of 4 under TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak"                 #VITIS_PARTITION directive of 10 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 10 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 10 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#"Coarse CFO"                             #VITIS_PARTITION directive of 11 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#                                         #VITIS_PARTITION directive of 11 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"Data Packer"                            #VITIS_PARTITION directive of 16 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#"Pkt Control"                            #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter
#           )

#Rev 1.4 Block LMS Manually Unrolled - AGC Removed
#partNames=(
#"RRC"                                    #VITIS_PARTITION directive of 1 under RootRaisedCosine
##"AGC"                                    #VITIS_PARTITION directive of 2 under AGC/AGCPwrAvg
##                                         #VITIS_PARTITION directive of 2 under AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under Subsystem
#"TR Golay Corr"                          #VITIS_PARTITION directive of 3 under TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#"TR Golay Peak"                          #VITIS_PARTITION directive of 4 under TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak"                 #VITIS_PARTITION directive of 10 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 10 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 10 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#"Coarse CFO"                             #VITIS_PARTITION directive of 11 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#                                         #VITIS_PARTITION directive of 11 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"Data Packer"                            #VITIS_PARTITION directive of 16 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#"Pkt Control"                            #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under SymbolDomainOuter
#           )

#Rev 1.5 Split Block LMS
#partNames=(
#"RRC"                                    #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
#"AGC"                                    #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCPwrAvg
#                                         #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under rx/Subsystem
#"TR Golay Corr"                          #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#"TR Golay Peak"                          #VITIS_PARTITION directive of 4 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak"                 #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#"Coarse CFO"                             #VITIS_PARTITION directive of 11 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"EQ Adapt"                               #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
#                                         #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
#"Data Packer"                            #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#"Pkt Control"                            #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter
#           )

#Rev 1.13 Combine Symbol Domain Corr and Coarse CFO
#partNames=(
#"RRC"                                    #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
#"AGC"                                    #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCPwrAvg
#                                         #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under rx/Subsystem
#"TR Golay Corr"                          #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#"TR Golay Peak"                          #VITIS_PARTITION directive of 4 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak & Coarse CFO"    #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"EQ Adapt"                               #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
#                                         #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
#"Data Packer"                            #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#"Pkt Control"                            #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 17 under rx/SymbolDomainOuter
#           )

##Rev 1.15 Combine Symbol Domain Corr and Coarse CFO, Pkt Ctrl and Data Packer
#partNames=(
#"RRC"                                    #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
#"AGC"                                    #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCPwrAvg
#                                         #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under rx/Subsystem
#"TR Golay Corr"                          #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#"TR Golay Peak"                          #VITIS_PARTITION directive of 4 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak & Coarse CFO"    #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"EQ Adapt"                               #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
#                                         #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
#"Pkt Control & Data Packer"              #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter
#           )

##Current fastest partitioning
#Rev 1.22 / 1.32 / 1.34 / 1.40 Combine GolayCorr and Golay Peak, Symbol Domain Corr and Coarse CFO, Pkt Ctrl and Data Packer
partNames=(
"RRC"                                    #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
"AGC"                                    #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCPwrAvg
                                         #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCLoopAndCorrect
                                         #VITIS_PARTITION directive of 2 under rx/Subsystem
"TR Golay Corr & Peak"                   #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
"TR Control"                             #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
                                         #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
                                         #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
"TR Var Delay"                           #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
                                         #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
"TR Early/Late"                          #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
"Symb Golay Corr & Peak & Coarse CFO"    #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
"EQ & Demod"                             #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
"EQ Adapt"                               #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
                                         #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
"Pkt Control & Data Packer"              #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter
           )

##Rev 1.35 Combine RRC and AGC, GolayCorr and Golay Peak, Symbol Domain Corr and Coarse CFO, Pkt Ctrl and Data Packer
#partNames=(
#"RRC & AGC"                              #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
#                                         #VITIS_PARTITION directive of 1 under rx/SampDomain/AGC/AGCPwrAvg
#                                         #VITIS_PARTITION directive of 1 under rx/SampDomain/AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under rx/Subsystem
#"TR Golay Corr & Peak"                   #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsample"               #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak & Coarse CFO"    #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#                                         #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"EQ Adapt"                               #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
#                                         #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
#"Pkt Control & Data Packer"              #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter
#           )

##Rev 1.37 Combine GolayCorr and Golay Peak, Var Delay and Symbol Clock, Symbol Domain Corr and Coarse CFO, Pkt Ctrl and Data Packer
#partNames=(
#"RRC"                                     #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
#"AGC"                                     #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCPwrAvg
#                                          #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCLoopAndCorrect
#                                          #VITIS_PARTITION directive of 2 under rx/Subsystem
#"TR Golay Corr & Peak"                    #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                          #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#                                          #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                              #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
#                                          #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                          #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum"  #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
#                                          #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
#                                          #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay & TR Symb Clk & Downsample" #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#                                          #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                          #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
#                                          #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#                                          #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#"TR Early/Late"                           #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
#"Symb Golay Corr & Peak & Coarse CFO"     #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                          #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                          #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#                                          #VITIS_PARTITION directive of 10 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#"EQ & Demod"                              #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
#                                          #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
#                                          #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"EQ Adapt"                                #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
#                                          #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
#"Pkt Control & Data Packer"               #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#                                          #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                          #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                          #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                          #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                          #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter
#           )

##Rev 1.38 Combine GolayCorr and Golay Peak, Symbol Clock and Symbol Domain Corr and Coarse CFO, Pkt Ctrl and Data Packer
#partNames=(
#"RRC"                                    #VITIS_PARTITION directive of 1 under rx/SampDomain/RootRaisedCosine
#"AGC"                                    #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCPwrAvg
#                                         #VITIS_PARTITION directive of 2 under rx/SampDomain/AGC/AGCLoopAndCorrect
#                                         #VITIS_PARTITION directive of 2 under rx/Subsystem
#"TR Golay Corr & Peak"                   #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect/GolayCorrelator
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter
#                                         #VITIS_PARTITION directive of 3 under rx/SampDomain/TimingRecoveryAndCorrelator/GolayCorrelatorAndPeakDetectOuter/GolayPeakDetect
#"TR Control"                             #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TRControl
#                                         #VITIS_PARTITION directive of 5 under rx/SampDomain/TimingRecoveryAndCorrelator/TrControlIntermediateOutputs
#                                         #VITIS_PARTITION directive of 5 under rx/ResetFeedbackAndPipelining
#"TR Error Calc & Freq Est & Delay Accum" #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/TRFreqEst
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/DelayAccum
#                                         #VITIS_PARTITION directive of 6 under rx/SampDomain/TimingRecoveryAndCorrelator/CalcDelayError
#"TR Var Delay"                           #VITIS_PARTITION directive of 7 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayWithSampleAlignment
#"TR Symb Clk & Downsamp & Symb Golay & Coarse CFO"  #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/VarDelayDecimSync
#                                         #VITIS_PARTITION directive of 8 under rx/SampDomain/TimingRecoveryAndCorrelator/SymbolClock
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DownsampleSymbol
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/dummyNode
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain/GolayCorrelator
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain/GolayPeakDetectSymbDomain
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/GolayPeakDetectSymbolDomain
#                                         #VITIS_PARTITION directive of 8 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/CoarseCFOCorrect
#"TR Early/Late"                          #VITIS_PARTITION directive of 9 under rx/SampDomain/TimingRecoveryAndCorrelator/EarlyLate
#"EQ & Demod"                             #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/VITIS_CLOCK_DOMAIN_UpdateCoefsEveryN/ToCorrection
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs/CoefUpdate/BreakComboLoop
#                                         #VITIS_PARTITION directive of 12 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ
#"EQ Adapt"                               #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/BlockLMS/AdaptCoefs
#                                         #VITIS_PARTITION directive of 13 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/EQ/LMSStepAdaptCtrl/LMSStep
#"Pkt Control & Data Packer"              #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/DataPacker
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxController
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/PacketRxControllerUpsample
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeController
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter/VITIS_CLOCK_DOMAIN_SymbolDomain/FreezeControllerUpsample
#                                         #VITIS_PARTITION directive of 16 under rx/SymbolDomainOuter
#           )

# CPU Frequency
#cpuFreqGHz=2.0
cpuFreqGHz=3.7

# Set the relevant paths to plot
if [[ $type == "cyclops" || $type == "cyclops2" ]]; then
  configPath=./genSrc/cOut_rev1BB_receiver/rx_demo_telemDump_telemConfig.json
  if [[ $type == "cyclops2" ]]; then
    configPath=./genSrc/cOut_rev1BB_receiver/rx_demo_inst2_telemDump_telemConfig.json
  fi
  telemPath=./results/rx
  reportPrefix=./resultsPlotted

  if [[ -z $title ]]; then
    #Old Limits: 0 0.07, 0 140, 0 4.0
    #Epyc Limits for Split Var Delay 0 0.25, 0 450, 0 14.0
    #Ryzen Limits for 16 Core Pipelined Var Delay 0 0.03, 0 140, 0 2.0
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --ylim 0 0.03 --output-file-prefix $reportPrefix --partition-names "${partNames[@]}"
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --ylim 0 140 --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz} --partition-names "${partNames[@]}"
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --output-file-prefix ${reportPrefix}_block --block-size 64 --ylim 0 2.0 --partition-names "${partNames[@]}"
    #"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --output-file-prefix ${reportPrefix}_summary --cpu-freq-ghz ${cpuFreqGHz} --summarize-fifos --partition-names "${partNames[@]}" &
  else
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --ylim 0 0.03 --output-file-prefix $reportPrefix --partition-names "${partNames[@]}" --title "$title"
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --ylim 0 140 --output-file-prefix ${reportPrefix}_cycles --cpu-freq-ghz ${cpuFreqGHz} --partition-names "${partNames[@]}" --title "$title"
    "$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --output-file-prefix ${reportPrefix}_block --block-size 64 --ylim 0 2.0 --partition-names "${partNames[@]}" --title "$title"
    #"$scriptSrc/plotLaminarPerformance.py" --config $configPath --telem-path $telemPath --discard-last-entry --discard-first-entry --output-file-prefix ${reportPrefix}_summary --cpu-freq-ghz ${cpuFreqGHz} --summarize-fifos --partition-names "${partNames[@]}" &
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