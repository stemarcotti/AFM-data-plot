import os
from glob import glob
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# this algorithm takes files from the AFM microscope (.txt) and plot them
# .png files are saved as output in a folder of choice

# 0_ INPUT
# here information about the experiment need to be entered
input_folder = 'D:/WORK/AFM/';	% where are raw data files
# where are the files going to be saved?
output_folder = 'D:/WORK/AFM/output/';	% name folder

# 1_ create list of files in folder
files = glob('{:s}*.txt'.format(input_folder))

# 2_ FOR loop to plot all data in files
for f in files:
    # 2a_ open data in file as dataframe
    data = pd.read_table(f, header=None, delim_whitespace=True)
    data.columns = ["height", "force", "series", "segment"]

    # 2b_ separate extend and retract
    length = len(data.segment)-1
    for i in range(length):
        if data.segment[i]-data.segment[i+1] > 0.1:
            segment_start = i+1

    extend = data[0:segment_start]
    retract = data[segment_start:]

    # 2c_ create plot
    fig = plt.figure

    sns.set_context("talk")
    sns.set_style("ticks")

    plt.plot(-extend.height, extend.force, label='extend')
    plt.plot(-retract.height, retract.force, label='retract')

    plt.xlabel('Height [nm]')
    plt.ylabel('Force [pN]')
    plt.legend()

    sns.despine()
    plt.tight_layout()

    # 2d_ save in output_folder
    plt.savefig('{:s}{:s}.png'.format(output_folder, f[:-4].rsplit('\\', 1)[-1]))
    plt.close()
