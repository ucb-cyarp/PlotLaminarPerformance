#!/usr/bin/env python3

# @author Christopher Yarp
# @date 11/02/2020
#
# This script plots telemetry information collected from Laminar processes

import argparse
import json
import warnings
import collections
import pandas as pd
import numpy as np
import typing
import matplotlib.pyplot as plt
import textwrap

PERIOD_CHECK_THRESHOLD = 0.001

class TelemFileFieldsNames:
    def __init__(self):
        self.computeTime = ''
        self.totalTime = ''
        self.waitingForInputFIFOs = ''
        self.readingInputFIFOs = ''
        self.waitingForOutputFIFOs = ''
        self.writingOutputFIFOs = ''
        self.telemetryMisc = ''
        self.totalTime = ''
        self.rate = ''

class PartitionStats:
    def __init__(self):
        # All Times in microseconds
        self.computeTimePerSampleAvg = 0.0
        self.waitingForInputFIFOsPerSampleAvg = 0.0
        self.readingInputFIFOsPerSampleAvg = 0.0
        self.waitingForOutputFIFOsPerSampleAvg = 0.0
        self.writingOutputFIFOsPerSampleAvg = 0.0
        self.telemetryMiscPerSampleAvg = 0.0
        # In MSPS (Mega-Samples Per Second)
        self.rateAvg = 0.0
        self.entries = 0

def getPartitionStats(telemPath : str, fieldNames : TelemFileFieldsNames, discardLastEntry : bool, discardFirstEntry : bool):
    partition_telem_raw = pd.read_csv(telemPath)

    if discardLastEntry and discardFirstEntry:
        if partition_telem_raw.shape[0] <= 2:
            print('Error, telemetry file {} has {} entries and discarding the first and last record was requested'.format(
                telemPath, partition_telem_raw.shape[0]))
            exit(1)
        partition_telem_raw = partition_telem_raw[1:-1]
    elif discardLastEntry:
        if partition_telem_raw.shape[0] <= 1:
            print('Error, telemetry file {} has {} entries and discarding the last record was requested'.format(
                telemPath, partition_telem_raw.shape[0]))
            exit(1)
        partition_telem_raw = partition_telem_raw[:-1]
    elif discardFirstEntry:
        if partition_telem_raw.shape[0] <= 1:
            print('Error, telemetry file {} has {} entries and discarding the first record was requested'.format(
                telemPath, partition_telem_raw.shape[0]))
            exit(1)
        partition_telem_raw = partition_telem_raw[1:]
    elif partition_telem_raw.shape[0] < 1:
        print('Error, telemetry file {} has {} entries'.format(
            telemPath, partition_telem_raw.shape[0]))
        exit(1)

    #With help from https://stackoverflow.com/questions/29530232/how-to-check-if-any-value-is-nan-in-a-pandas-dataframe
    if partition_telem_raw.isna().values.any():
        print('Error, telemetry file {} imported with NAN values.  Telemetry file may be corrupted.'.format(telemPath))
        exit(1)

    # Need to reset the index if the first row is removed
    partition_telem_raw.reset_index(inplace=True, drop=True)

    secPerMSample = 1.0/partition_telem_raw[fieldNames.rate]
    secPerMSampleAvg = secPerMSample.mean()
    mspsAvg = 1.0/secPerMSampleAvg

    stats = PartitionStats()
    stats.rateAvg = mspsAvg

    # IMPORTANT NOTES:
    # Note, the number of samples processed is not returned by the telemetry.  The rate of sample processing in each
    # time segment is returned.  We take the average rate (actually average the time per sample and invert that).
    # We then use this rate, and the average amount of time spent in each phase of evaluation, to estimate the amount of
    # time it takes each stage on to process each sample.

    totalTime = partition_telem_raw[fieldNames.totalTime].sum()
    estimatedMegaSamplesProcessed = mspsAvg*totalTime

    computeTime = partition_telem_raw[fieldNames.computeTime].sum()
    stats.computeTimePerSampleAvg = computeTime/estimatedMegaSamplesProcessed
    waitingForInputFIFOsTime = partition_telem_raw[fieldNames.waitingForInputFIFOs].sum()
    stats.waitingForInputFIFOsPerSampleAvg = waitingForInputFIFOsTime/estimatedMegaSamplesProcessed
    readingInputFIFOsTime = partition_telem_raw[fieldNames.readingInputFIFOs].sum()
    stats.readingInputFIFOsPerSampleAvg = readingInputFIFOsTime/estimatedMegaSamplesProcessed
    waitingForOutputFIFOsTime = partition_telem_raw[fieldNames.waitingForOutputFIFOs].sum()
    stats.waitingForOutputFIFOsPerSampleAvg = waitingForOutputFIFOsTime/estimatedMegaSamplesProcessed
    writingOutputFIFOsTime = partition_telem_raw[fieldNames.writingOutputFIFOs].sum()
    stats.writingOutputFIFOsPerSampleAvg = writingOutputFIFOsTime/estimatedMegaSamplesProcessed
    telemetryMiscTime = partition_telem_raw[fieldNames.telemetryMisc].sum()
    stats.telemetryMiscPerSampleAvg = telemetryMiscTime/estimatedMegaSamplesProcessed
    stats.entries = partition_telem_raw.shape[0]

    # Sanity Check the I/O
    for i in range(1, partition_telem_raw.shape[0]):
        if abs(partition_telem_raw[fieldNames.totalTime][i] - partition_telem_raw[fieldNames.totalTime][0])/partition_telem_raw[fieldNames.totalTime][0] > PERIOD_CHECK_THRESHOLD:
            print('Warning!: Entry {} Total Time ({}) is significantly different from the first ({}).  May indicate an issue with this record'.format(i ,partition_telem_raw[fieldNames.totalTime][i], partition_telem_raw[fieldNames.totalTime][0]))

    return stats

def setup():
    #Parse CLI Arguments for Config File Location
    parser = argparse.ArgumentParser(description='Plots telemetry information collected from Laminar process')
    parser.add_argument('--config', type=str, required=True, help='Path to the telemetry configuration JSON file')
    parser.add_argument('--telem-path', type=str, required=True, help='Path to the telemetry files referenced in the configuration JSON file')
    parser.add_argument('--discard-last-entry', action='store_true', help='If true, discard the last entry in the telemetry file.  Useful if there are concerns that the last entry may be corrupted')
    parser.add_argument('--discard-first-entry', action='store_true', help='If true, discard the first entry in the telemetry file.  Useful if there are concerns that the first entry may be incorrect (startup or doubleBufferInit)')

    args = parser.parse_args()

    # print(args)

    json_path = args.config
    telem_path = args.telem_path

    #Print the CLI options for debugging
    print('Config Path: ' + json_path);
    print('Telemetry Path: ' + telem_path);

    #Load the JSON Telemetry Config File
    config_file = None
    try:
        config_file = open(json_path)
    except Exception as err:
        print('Error encountered when reading config file')
        print(err)
        exit(1)
    telem_config = json.load(config_file)
    config_file.close()

    #Get the telemetry files from the Config
    telem_files = telem_config['computeTelemFiles']

    #Check the Mapping of Partitions, Telemetry Files, and Names
    #Check if the partitionFiles were listed in ascending order.  If not, the partition->name mapping provided by the user
    #may be incorrect
    partition_nums = [int(x) for x in telem_files.keys()]
    partition_nums_sorted = sorted(partition_nums)

    #Get maps of partition numbers (as ints) to names and telemetry files
    partitionNameMap = {}
    partitionFileMap = {}
    for i, partitionNum in enumerate(partition_nums_sorted):
        partitionFileMap[partitionNum] = telem_files[str(partitionNum)]
        partitionNameMap[partitionNum] = 'Partition ' + str(partitionNum)

    #Print the Name -> Partition Mapping
    # print("Partition Names & Files:")
    # for partitionNum in partition_nums_sorted:
    #     print('\tPartition ' + str(partitionNum) + ': ' + partitionNameMap[partitionNum] + ', ' + partitionFileMap[partitionNum] )

    #Get the data labels from the Config
    field_names = TelemFileFieldsNames()
    field_names.computeTime = telem_config['computeTimeMetricName']
    field_names.totalTime = telem_config['totalTimeMetricName']
    field_names.waitingForInputFIFOs = telem_config['waitingForInputFIFOsMetricName']
    field_names.readingInputFIFOs = telem_config['readingInputFIFOsMetricName']
    field_names.waitingForOutputFIFOs = telem_config['waitingForOutputFIFOsMetricName']
    field_names.writingOutputFIFOs = telem_config['writingOutputFIFOsMetricName']
    field_names.telemetryMisc = telem_config['telemetryMiscMetricName']
    field_names.totalTime = telem_config['totalTimeMetricName']
    field_names.rate = telem_config['rateMSPSName']

    RtnType = collections.namedtuple('SetupRtn', ['partitionNameMap', 'partitionFileMap', 'fieldNames', 'partitions',
                                                  'telemPath', 'discardLastEntry', 'discardFirstEntry'])

    rtn_val = RtnType(partitionNameMap=partitionNameMap, partitionFileMap=partitionFileMap, fieldNames=field_names,
                      partitions=partition_nums_sorted, telemPath=telem_path, discardLastEntry=args.discard_last_entry,
                      discardFirstEntry=args.discard_first_entry)
    return rtn_val

def reportEntries(partitionStats: typing.Dict[int, PartitionStats],
                  partitionNames: typing.Dict[int, PartitionStats],
                  partitions: typing.List[int]):
    for partitionNum in partitions:
        print(partitionNames[partitionNum] + ' (Partition ' + str(partitionNum) + ') Telem Entries: ' + str(partitionStats[partitionNum].entries))

def main():
    setup_rtn = setup()

    partitionStats = {}
    for partitionNum in setup_rtn.partitions:
        if setup_rtn.telemPath == '':
            telemFilePath = setup_rtn.partitionFileMap[partitionNum]
        else:
            telemFilePath = setup_rtn.telemPath + '/' + setup_rtn.partitionFileMap[partitionNum]
        partitionStats[partitionNum] = getPartitionStats(telemPath=telemFilePath, fieldNames=setup_rtn.fieldNames,
                                                         discardLastEntry=setup_rtn.discardLastEntry,
                                                         discardFirstEntry=setup_rtn.discardFirstEntry)

    reportEntries(partitionStats, setup_rtn.partitionNameMap, setup_rtn.partitions)

if __name__ == '__main__':
    main()

