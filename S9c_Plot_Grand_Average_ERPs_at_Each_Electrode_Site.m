% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin March 2022
% Operates on data averaged across participants
% This script loads the specificed grand average ERP waveforms, plots the 
% grand average waveforms by each specified electrodes site, and saves .tif
% files of all of the plots in the grand average ERPs folder.

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
xscale = [-100.0 1000.0   0:200:1000];

% Set y-axis scale in microvolts for the EEG channels for the waves
yscale_EEG_parent = [-6.0 6.0   -6 6]; 

% Key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
channels = [7 9 14 17 27 31 38 42 44 48 51 54 64]

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%List of the grand average ERP waveforms in .erp ERPLAB file format to load
GAfile = {'_lpfilt_OldCons','_lpfilt_Aphasics'};

for i = 1:length(GAfile)
    ERP = pop_loaderp('filename', ['GA_ERPs' GAfile '.erp'], 'filepath', Current_File_Path);    

    % Plot (and save the images of) the waveforms of unprimed targets and
    % delayed reps of primes at each of key electrode sites of interest
    for i 1:length(channels)
    ERP = pop_ploterps( ERP, [4 7 8], channels , 'Box', [1 1], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Current_File_Path filesep ['GA' GAfile '_' channels '.tif']]);
    close all


%*************************************************************************************************************************************
