% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin September 2021
% Operates on data averaged across participants
% This script loads the low-pass filtered grand average ERP waveforms,
% plots the grand average waveforms and saves the plots as .jpg files in
% the grand average ERPs folder.

close all; clearvars;

% Location of the main study directory
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = /Users/KappenmanLab/ERP_CORE/N400
% DIR = fileparts(fileparts(mfilename('fullpath'))); 
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

% Location of the folder that contains this script and any associated processing files
% This method of specifying the current file path only works if you run the
% script; for running individual lines of code, replace the current file
% path with the path on your computer, e.g.: 
% Current_File_Path = /Users/KappenmanLab/ERP_CORE/N400/EEG_ERP_Processing/Grand_Average_ERPs
% Current_File_Path = fileparts(mfilename('fullpath'));
Current_File_Path = '/Volumes/verb/EMPIA/Participant EEG Data/Grand Averages';

%*************************************************************************************************************************************

% Set baseline correction period in milliseconds
baselinecorr = '-100 0';

% Set x-axis scale in milliseconds
xscale = [-100.0 900.0   -100:100:900];

% Set y-axis scale in microvolts for the EEG channels for the parent waves
yscale_EEG_parent = [-6.0 6.0   -6:2:6];

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Load the low-pass filtered grand average ERP waveforms in .erp ERPLAB file format
ERP = pop_loaderp('filename', 'GA_ERPs_12Hzlpfilt_OldCons.erp', 'filepath', Current_File_Path);

% Plot the waveforms at the electrode site(s) of interest 
% Electrode channels: F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2
% Channel numbers:    7    9   14   17  27  31  38  42  44   48  51  54  64
% Bins:         Animal Primes  Non-animal Primes  Animal Targets
% Bin numbers:        1                 2               3
% Bins:         Non-animal Targets/  Immediate      Unrelated Primes
%               No Primes            Masked Primes  
% Bin numbers:        4                 5               6
% Bins:         Delayed Masked  Delayed Visible  
%               Primes          Primes  
% Bin numbers:        7                 8 
ERP = pop_ploterps( ERP, [7 8], [48] , 'Box', [1 1], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[Current_File_Path filesep 'GA_N400_DMPvDVP_OldCons_12Hzlpfilt.jpg']);