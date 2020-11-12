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

def getPartitionStats(telemPath : str, fieldNames : TelemFileFieldsNames):
    partition_telem_raw = pd.read_csv(telemPath)

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

    return stats

def setup():
    #Parse CLI Arguments for Config File Location
    parser = argparse.ArgumentParser(description='Plots telemetry information collected from Laminar process')
    parser.add_argument('--config', type=str, required=True, help='Path to the telemetry configuration JSON file')
    parser.add_argument('--telem-path', type=str, required=True, help='Path to the telemetry files referenced in the configuration JSON file')
    parser.add_argument('--output-file-prefix', type=str, required=False, help='If supplied, plots will be written to files with this given prefix')
    parser.add_argument('--prj-name', type=str, required=False, help='A human readable name for the project, if not provided the name is pulled from the telemetry config file')
    parser.add_argument('--summarize-fifos', required=False, action='store_true', help='Combines the actions for input & output FIFOs')
    parser.add_argument('--cpu-freq-ghz', required=False, type=float, help='CPU Clk Frequency in GHz.  If supplied (positive), result will be presented in estimated cycles/sample')
    parser.add_argument('--ylim', required=False, type=float, nargs=2, help='The y limits (low, high).  If supplied, overrides the automatic y limit')
    parser.add_argument('--partition-names', nargs='+', type=str, required=False, help='List of human readable names corresponding to each partition (in ascending order of partitions)')

    args = parser.parse_args()

    # print(args)

    json_path = args.config
    telem_path = args.telem_path
    part_names = args.partition_names

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
    if partition_nums != partition_nums_sorted:
        warnings.warn("Partitions in Telemetry Configuration File Were Not Listed in Sorted Order. "
                      " Provided Names May be Incorrect")

    if (part_names is not None) and len(part_names) != len(partition_nums_sorted):
        warnings.warn("Number of Provided Names Does Not Match Number of Compute Partitions. "
                      " Provided Names May be Incorrect")

    #Get maps of partition numbers (as ints) to names and telemetry files
    partitionNameMap = {}
    partitionFileMap = {}
    for i, partitionNum in enumerate(partition_nums_sorted):
        partitionFileMap[partitionNum] = telem_files[str(partitionNum)]
        if part_names is not None:
            if i < len(part_names):
                partitionNameMap[partitionNum] = part_names[i]
            else:
                partitionNameMap[partitionNum] = 'Partition ' + str(partitionNum)
        else:
            partitionNameMap[partitionNum] = 'Partition ' + str(partitionNum)

    #Print the Name -> Partition Mapping
    print("Partition Names & Files:")
    for partitionNum in partition_nums_sorted:
        print('\tPartition ' + str(partitionNum) + ': ' + partitionNameMap[partitionNum] + ', ' + partitionFileMap[partitionNum] )

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
                                                  'telemPath', 'prj_name', 'outputPrefix', 'summarizeFIFOs',
                                                  'clkFreqGHz', 'yLim'])

    if args.prj_name is None:
        prj_name = telem_config['name']
    else:
        prj_name = args.prj_name

    clkFreqGHz = args.cpu_freq_ghz # It is OK if this is None, will be handled later

    yLim = args.ylim

    if yLim is not None:
        if yLim[0] >= yLim[1]:
            raise ValueError('y Limit should be supplied with the lowest number first')

    rtn_val = RtnType(partitionNameMap=partitionNameMap, partitionFileMap=partitionFileMap, fieldNames=field_names,
                      partitions=partition_nums_sorted, telemPath=telem_path, prj_name=prj_name,
                      outputPrefix=args.output_file_prefix, summarizeFIFOs=args.summarize_fifos,
                      clkFreqGHz=clkFreqGHz, yLim=yLim)
    return rtn_val

def plotLayer(values, lbl, x_lbls, y_offset, bar_width, tableTxt: typing.List[str], tableLbls: typing.List[str], colors,
              cmap, layerNum):
    colors.append(cmap(layerNum))
    plt.bar(x_lbls, values, bar_width, bottom=y_offset, color=cmap(layerNum))
    tableTxt.append(['%1.4f' % x for x in values])
    tableLbls.append(lbl)
    y_offset+=values
    return layerNum+1

def wrapText(text: str, width: int):
    wrappedText = textwrap.wrap(text, width=width)
    numLines = len(wrappedText)

    return (numLines, "\n".join(wrappedText))

# Set annotation heights so that text does not overlap
# Will place annotations below conflicting ones
def determineAnnotationYPos(desiredYPos: typing.List[float], right: typing.List[bool], height: float):
    # Sort the desired positions in decending order since we will be placing conflicting labels lower
    desiredYPosPd = pd.Series(desiredYPos)
    #TODO: Clean this up after reviewing pandas semantics for indexing into sorted array
    desiredYPosPd.sort_values(ascending=False, inplace=True)
    desiredYPosInd = desiredYPosPd.index
    selectedYPosPd = [0.0]*len(desiredYPos)

    lastLeftY = None
    lastRightY = None

    for i in desiredYPosInd:
        # Check the last entry to determine if this position overlaps
        # Since we are sorted, if yPos+height > lastYPos, then this pos must be set to lastYPos-height
        # That is because, even if yPos+height > lastYPos+height (is completely above the last block), it could only
        # occure because the last block was moved due to a conflict (since it should have been before this block in the
        # sorted list)
        if right[i]:
            if lastRightY is None:
                lastRightY = desiredYPos[i]
                selectedYPosPd[i] = desiredYPos[i]
            elif desiredYPos[i] + height > lastRightY:
                conflictPos = lastRightY - height
                lastRightY = conflictPos
                selectedYPosPd[i] = conflictPos
            else:
                lastRightY = desiredYPos[i]
                selectedYPosPd[i] = desiredYPos[i]
        else:
            if lastLeftY is None:
                lastLeftY = desiredYPos[i]
                selectedYPosPd[i] = desiredYPos[i]
            elif desiredYPos[i] + height > lastLeftY:
                conflictPos = lastLeftY - height
                lastLeftY = conflictPos
                selectedYPosPd[i] = conflictPos
            else:
                lastLeftY = desiredYPos[i]
                selectedYPosPd[i] = desiredYPos[i]

    return selectedYPosPd

def wrapLbls(lbls):
    # Wrap the label text
    # TODO: Set the number of characters for the wrap dynamically based on the font size
    #       See https://matplotlib.org/3.1.1/_modules/matplotlib/table.html#Cell.auto_set_font_size
    #       For ideas on how one might go about doing this
    numChars = 14
    lbls_wrapped = []
    lbls_maxnumlines = 1
    for lbl in lbls:
        numLines, txt = wrapText(lbl, numChars)
        lbls_maxnumlines = max(lbls_maxnumlines, numLines)
        lbls_wrapped.append(txt)
    return lbls_wrapped, lbls_maxnumlines

def plotStats(partitionStats: typing.Dict[int, PartitionStats],
              partitionNames: typing.Dict[int, PartitionStats],
              partitions: typing.List[int],
              prj_name: str,
              summarizeFIFO: bool,
              outputPrefix: str,
              cpuFreqGhz: float,
              yLim: typing.List[float]):

    # See https://matplotlib.org/gallery/lines_bars_and_markers/bar_stacked.html#sphx-glr-gallery-lines-bars-and-markers-bar-stacked-py
    # for information on making stacked bar plots
    # See https://matplotlib.org/3.1.1/gallery/misc/table_demo.html#sphx-glr-gallery-misc-table-demo-py for information
    # on putting tables below plots (and for making another stacked bar plot)

    # For info on colormaps and accessing a specific color in the colormap, see:
    # https://matplotlib.org/3.3.2/tutorials/colors/colormaps.html
    # https://stackoverflow.com/questions/25408393/getting-individual-colors-from-a-color-map-in-matplotlib

    reportEstCycles: bool = cpuFreqGhz is not None
    overrideYLim: bool = yLim is not None

    bar_width = 0.35

    x_lbls = np.array([partitionNames[x] for x in partitions])

    cmap = plt.get_cmap('tab10')

    #For getting gridlines behind bars: https://stackoverflow.com/questions/1726391/matplotlib-draw-grid-lines-behind-other-graph-elements/1726527
    fig = plt.figure(figsize=[15, 8])
    ax = fig.add_subplot(1, 1, 1)

    tableTxt = []
    tableLbls = []
    colors = []
    y_offset = np.zeros(len(x_lbls)) # Need to accumulate offset for the bars as we plot each new layer
    layerNum = 0

    computeTime = np.array([partitionStats[x].computeTimePerSampleAvg for x in partitions])
    if reportEstCycles:
        computeTime *= cpuFreqGhz * 1.0e3

    layerNum = plotLayer(values=computeTime, lbl='Compute', x_lbls=x_lbls, y_offset=y_offset,
                         bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls, colors=colors, cmap=cmap,
                         layerNum=layerNum)

    waitingForInputFIFOsTime = np.array([partitionStats[x].waitingForInputFIFOsPerSampleAvg for x in partitions])
    waitingForOutputFIFOsTime = np.array([partitionStats[x].waitingForOutputFIFOsPerSampleAvg for x in partitions])
    readingInputFIFOsTime = np.array([partitionStats[x].readingInputFIFOsPerSampleAvg for x in partitions])
    writingOutputFIFOsTime = np.array([partitionStats[x].writingOutputFIFOsPerSampleAvg for x in partitions])
    if reportEstCycles:
        waitingForInputFIFOsTime *= cpuFreqGhz * 1.0e3
        waitingForOutputFIFOsTime *= cpuFreqGhz * 1.0e3
        readingInputFIFOsTime *= cpuFreqGhz * 1.0e3
        writingOutputFIFOsTime *= cpuFreqGhz * 1.0e3

    if summarizeFIFO:
        waitingForFIFOsTime = waitingForInputFIFOsTime + waitingForOutputFIFOsTime
        layerNum = plotLayer(values=waitingForFIFOsTime, lbl='Waiting for FIFOs', x_lbls=x_lbls,
                             y_offset=y_offset, bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls,
                             colors=colors, cmap=cmap, layerNum=layerNum)

        readingWritingFIFOs = readingInputFIFOsTime + writingOutputFIFOsTime
        layerNum = plotLayer(values=readingWritingFIFOs, lbl='Reading/Writing FIFOs', x_lbls=x_lbls,
                             y_offset=y_offset, bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls,
                             colors=colors, cmap=cmap, layerNum=layerNum)
    else:
        layerNum = plotLayer(values=waitingForInputFIFOsTime, lbl='Waiting for Input FIFOs', x_lbls=x_lbls,
                             y_offset=y_offset, bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls,
                             colors=colors, cmap=cmap, layerNum=layerNum)
        layerNum = plotLayer(values=waitingForOutputFIFOsTime, lbl='Waiting for Output FIFOs',
                             x_lbls=x_lbls,
                             y_offset=y_offset, bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls,
                             colors=colors, cmap=cmap, layerNum=layerNum)
        layerNum = plotLayer(values=readingInputFIFOsTime, lbl='Reading Input FIFOs',
                             x_lbls=x_lbls,
                             y_offset=y_offset, bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls,
                             colors=colors, cmap=cmap, layerNum=layerNum)
        layerNum = plotLayer(values=writingOutputFIFOsTime, lbl='Writing Output FIFOs',
                             x_lbls=x_lbls,
                             y_offset=y_offset, bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls,
                             colors=colors, cmap=cmap, layerNum=layerNum)

    telemetryMiscTime = np.array([partitionStats[x].telemetryMiscPerSampleAvg for x in partitions])
    if reportEstCycles:
        telemetryMiscTime *= cpuFreqGhz * 1.0e3

    layerNum = plotLayer(values=telemetryMiscTime, lbl='Telemetry/Misc', x_lbls=x_lbls, y_offset=y_offset,
                         bar_width=bar_width, tableTxt=tableTxt, tableLbls=tableLbls, colors=colors, cmap=cmap,
                         layerNum=layerNum)

    #In accordance with the tutorial, reverse the text rows and colors so that the order matches the bar graph
    tableLbls.reverse()
    tableTxt.reverse()
    colors = colors[::-1]

    x_lbls_wrapped, x_lblx_numlines = wrapLbls(x_lbls)

    tbl = plt.table(cellText=tableTxt,
                    rowLabels=tableLbls,
                    rowColours=colors,
                    colLabels=x_lbls_wrapped,
                    loc='bottom')
    # tbl.auto_set_font_size(False)
    # tbl.set_fontsize(10)

    # Help making table headers bold: https://stackoverflow.com/questions/52429323/python-making-column-row-labels-of-matplotlib-table-bold
    cellHeight = 0
    for (row, col), cell in tbl.get_celld().items():
        # if (row == 0) or (col == -1):
            # cell.set_text_props(weight='bold', wrap=True)
        if row == 0:
            cellHeight = cell.get_height()

    # Now for a little bit of a hacky way of getting multiple lines in the table header
    figHeight = fig.get_size_inches()[1]
    newCellHeight = cellHeight*1.1*x_lblx_numlines
    for (row, col), cell in tbl.get_celld().items():
        if row == 0:
            cell.set_height(newCellHeight)

    #From the Tutorial for moving the layout to make room for a table
    plt.subplots_adjust(left=0.15, bottom=0.2, right=0.975, top=0.95)

    #Set lables
    if reportEstCycles:
        plt.ylabel('Estimated Cycles/Sample - Avg ({} GHz Clk)'.format(cpuFreqGhz))
    else:
        plt.ylabel('Time (us/Sample - Avg)')
    plt.xticks([])
    if overrideYLim:
        plt.ylim(yLim)
    plt.title('Workload Distribution: ' + prj_name)
    ax.set_axisbelow(True)
    plt.grid()

    if outputPrefix is not None:
        plt.savefig(outputPrefix+'_bar.pdf', format='pdf')

def plotComputePieStats(partitionStats: typing.Dict[int, PartitionStats],
                        partitionNames: typing.Dict[int, PartitionStats],
                        partitions: typing.List[int],
                        prj_name: str,
                        summarizeFIFO: bool,
                        outputPrefix: str):

    # Create a Pie Chart
    # See https://matplotlib.org/3.1.1/gallery/pie_and_polar_charts/pie_features.html#sphx-glr-gallery-pie-and-polar-charts-pie-features-py
    # and https://matplotlib.org/3.1.1/gallery/pie_and_polar_charts/pie_and_donut_labels.html#sphx-glr-gallery-pie-and-polar-charts-pie-and-donut-labels-py

    computeTime = np.array([partitionStats[x].computeTimePerSampleAvg for x in partitions])
    x_lbls = np.array([partitionNames[x] for x in partitions])
    x_lbls_wrapped, x_lblx_numlines = wrapLbls(x_lbls)

    computeTimePercent = computeTime*100.0/computeTime.sum()
    pieLblInsideThreshold = 5

    fig_pie = plt.figure(figsize=[8, 5])
    ax_pie = fig_pie.add_subplot(1, 1, 1)
    wedges, texts, autotexts = ax_pie.pie(computeTimePercent,
                                          autopct=lambda val: '%1.1f%%' % val if val>=pieLblInsideThreshold else '',
                                          startangle=90)
    ax_pie.axis('equal')
    ax_pie.legend(wedges, x_lbls_wrapped,
              title="Partitions",
              loc="center left")

    # The settings for annotation boxes are
    # https://matplotlib.org/3.1.1/gallery/pie_and_polar_charts/pie_and_donut_labels.html#sphx-glr-gallery-pie-and-polar-charts-pie-and-donut-labels-py
    bbox_props = dict(boxstyle="square,pad=0.3", facecolor="None", edgecolor="None")

    kw = dict(arrowprops=dict(arrowstyle="-"),
              bbox=bbox_props, zorder=0, va="center")

    txtLbls = ['%1.1f%%' % p for p in computeTimePercent]

    # TODO: get this from the renderer
    annotationVspace = 0.2

    # Need to get parameters for annotations to correct for text overlap
    annotationWedgeInd = []
    annotationXY = []
    annotationRight = []
    annotationDesiredY = []
    annotationAng = []
    annotationTxtLbl = []

    # The math for computing the position of annotations and connectors is a modified version of the code in the turorial
    # https://matplotlib.org/3.1.1/gallery/pie_and_polar_charts/pie_and_donut_labels.html#sphx-glr-gallery-pie-and-polar-charts-pie-and-donut-labels-py
    for i, p in enumerate(wedges):
        if computeTimePercent[i] < pieLblInsideThreshold:
            annotationWedgeInd.append(i)
            ang = (p.theta2 - p.theta1) / 2. + p.theta1
            annotationAng.append(ang)
            y = np.sin(np.deg2rad(ang))
            x = np.cos(np.deg2rad(ang))
            annotationXY.append((x, y))
            annotationRight.append(True if x >= 0 else False)
            annotationDesiredY.append(1.4 * y)
            annotationTxtLbl.append(txtLbls[i])

    annotationLblY = determineAnnotationYPos(annotationDesiredY, annotationRight, annotationVspace)

    for i in range(0, len(annotationWedgeInd)):
        horizontalalignment = "right" if annotationRight[i] else "left"
        # connectionstyle = "angle,angleA=0,angleB={}".format(annotationAng[i])
        # kw["arrowprops"].update({"connectionstyle": connectionstyle})
        ax_pie.annotate(annotationTxtLbl[i], xy=annotationXY[i], xytext=(1.5 * (1.0 if annotationRight[i] else -1.0), annotationLblY[i]),
                        horizontalalignment=horizontalalignment, **kw)

    ax_pie.set_title("Compute Workload Distribution: " + prj_name, y=1.2)
    plt.subplots_adjust(left=0.02, bottom=0.2, right=0.98, top=0.8)

    if outputPrefix is not None:
        plt.savefig(outputPrefix+'_pie.pdf', format='pdf')


def reportRates(partitionStats: typing.Dict[int, PartitionStats],
                partitionNames: typing.Dict[int, PartitionStats],
                partitions: typing.List[int]):
    for partitionNum in partitions:
        print(partitionNames[partitionNum] + '(Partition ' + str(partitionNum) + ') Rate (MSPS): ' + str(partitionStats[partitionNum].rateAvg))

def main():
    setup_rtn = setup()

    partitionStats = {}
    for partitionNum in setup_rtn.partitions:
        if setup_rtn.telemPath == '':
            telemFilePath = setup_rtn.partitionFileMap[partitionNum]
        else:
            telemFilePath = setup_rtn.telemPath + '/' + setup_rtn.partitionFileMap[partitionNum]
        partitionStats[partitionNum] = getPartitionStats(telemPath=telemFilePath, fieldNames=setup_rtn.fieldNames)

    reportRates(partitionStats, setup_rtn.partitionNameMap, setup_rtn.partitions)

    plotStats(partitionStats, setup_rtn.partitionNameMap, setup_rtn.partitions, setup_rtn.prj_name,
              setup_rtn.summarizeFIFOs, setup_rtn.outputPrefix, setup_rtn.clkFreqGHz, setup_rtn.yLim)

    plotComputePieStats(partitionStats, setup_rtn.partitionNameMap, setup_rtn.partitions, setup_rtn.prj_name,
                        setup_rtn.summarizeFIFOs, setup_rtn.outputPrefix)

    # Based on https://stackoverflow.com/questions/28269157/plotting-in-a-non-blocking-way-with-matplotlib
    # need a final plt.show() to force drawing to occur for all of the non-blocking instances
    plt.show()

if __name__ == '__main__':
    main()

