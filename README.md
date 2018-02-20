# AFM data plot
Matlab coding for AFM raw data plotting.  
All codes were tested on Matlab R2017b version

#### Raw data
The raw data are force-spectroscopy .txt files from AFM experiments, preprocessed to fit the contact point.
They contain four columns: cantilever height [nm], cantilever vertical deflection [nN], series time [s], segment time [s].
All the experiments were carried out with a Nanowizard 3 microscope from JPK.
The built-in software provide .txt files in this form (comments are preceded by #).

#### Plot
Matlab code *AFMplot.m*.
This code does the following
* takes as _input_ the .txt data,
* plot the force spectroscopy extend and retract curves,
* gives as _output_ a .png image file for each .txt and save it in the output folder.
