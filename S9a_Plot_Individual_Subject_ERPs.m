% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% Operates on individual subject data 
% This script loads the low-pass filtered averaged ERP waveforms, plots the
% individual subject waveforms, ICA-corrected and uncorrected HEOG, and
% ICA-corrected VEOG, and saves .jpg files of all of the plots in the graphs
% folder located within each subjects's data folder.

close all; clearvars;

% Location of the main study directory, based on where this script is saved
% This method of specifying the study directory only works if you run the
% script; for running individual lines of code, replace the study directory
% with the path on your computer, e.g.: 
% DIR = fileparts(fileparts(mfilename('fullpath')));
DIR = '/Volumes/verb/EMPIA/Participant EEG Data';

% List of subjects to process, based on the name of the folder that contains that subject's data
SUB = {'a301', 'a302', 'a304' 'a305', 'a307', 'a312','a314', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104', 't109','t113', 't117', 't120', 't121', 't122', 't123', 't124' 't125', 't128','t130', 't133', 'a306'};

% Subjects to process: 'a308', 'a309', 'a311', 'a315', 't105', 't106',
% 't111', 't115', 't119'

% Processed subjects: 'a301', 'a302', 'a304' 'a305', 'a307', 'a312',
% 'a314', 'a317', 'a318' 'a319', 'a320', 'a322', 'a323', 't104', 't109',
% 't113', 't117', 't120', 't121', 't122', 't123', 't124' 't125', 't128',
% 't130', 't133', 'a306'

%**********************************************************************************************************************************************************************

% Set baseline correction period in milliseconds
baselinecorr = '-100 0';

% Set x-axis scale in milliseconds
xscale = [-100.0 1180.0   -100:100:1180];

% Set y-axis scale in microvolts for the EEG channels for the parent waves
yscale_EEG_parent = [-15.0 15.0   -15:5:15]; %[-20.0 30.0   -20:10:30];

% Set y-axis scale in microvolts for the ICA-corrected and uncorrected bipolar HEOG channels
yscale_HEOG = [-25.0 25.0   -25:10:25]; %[-15.0 15.0   -15:5:15];

% Set y-axis scale in microvolts for the ICA-corrected monopolar VEOG signals and corrected bipolar VEOG signal
yscale_VEOG = [-25.0 25.0   -25:10:25];

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    
% Loop through each subject listed in SUB
for i = 1:length(SUB)
    
    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the low-pass filtered averaged ERP waveforms outputted in .erp ERPLAB file format
    ERP = pop_loaderp('filename', [SUB{i} '_ERPs_CorrBinLabs_lpfilt.erp'], 'filepath', Subject_Path);    
    

    %%% Animal Primes vs. Non-animal Primes %%%
    % Plot the animal primes and non-animal primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
    ERP = pop_ploterps( ERP, [1 2], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalPrimes_IndivWaves.jpg']);
    close all

    % Plot the animal primes and non-animal primes individual waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [1 2], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalPrimes_IndivWaves_AllChans.jpg']);
    close all
  
    % Plot the individual (animal primes and non-animal primes conditions)
    ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
    non-bipolar channels here)
    ERP = pop_ploterps( ERP, [1 2], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalPrimes_ROC.jpg']);
    close all
    
    % Plot the individual (animal primes and non-animal primes conditions)
    % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
    % signal (only ICA-corrected non-bipolar channels here)
    ERP = pop_ploterps( ERP, [1 2], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalPrimes_LIO.jpg']);
    close all


    %%% Animal Targets vs. Non-animal Targets %%%
    % Plot the animal targets and non-animal targets individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
    ERP = pop_ploterps( ERP, [3 4], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalTargets_IndivWaves.jpg']);
    close all

    % Plot the animal targets and non-animal targets individual waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [3 4], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalTargets_IndivWaves_AllChans.jpg']);
    close all
  
    % Plot the individual (animal targets and non-animal targets conditions)
    % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
    % non-bipolar channels here)
    ERP = pop_ploterps( ERP, [3 4], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalTargets_ROC.jpg']);
    close all
    
    % Plot the individual (animal targets and non-animal targets conditions)
    % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
    % signal (only ICA-corrected non-bipolar channels here)
    ERP = pop_ploterps( ERP, [3 4], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_AnimalvsNonanimalTargets_LIO.jpg']);
    close all


    %%% Immediate Masked Primes vs. No (Unrelated) Primes %%%
    % Plot the immediate masked primes and no (unrelated) primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
    ERP = pop_ploterps( ERP, [5 6], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_ImmMaskedPrimesvsNoPrimes_IndivWaves.jpg']);
    close all

    % Plot the immediate masked primes and no (unrelated) primes individual waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [5 6], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_ImmMaskedPrimesvsNoPrimes_IndivWaves_AllChans.jpg']);
    close all
  
    % Plot the individual (immediate masked primes and no (unrelated) primes conditions)
    % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
    % non-bipolar channels here)
    ERP = pop_ploterps( ERP, [5 6], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_ImmMaskedPrimesvsNoPrimes_ROC.jpg']);
    close all
    
    % Plot the individual (immediate masked primes and no (unrelated) primes conditions)
    % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
    % signal (only ICA-corrected non-bipolar channels here)
    ERP = pop_ploterps( ERP, [5 6], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_ImmMaskedPrimesvsNoPrimes_LIO.jpg']);
    close all


    %%% Delayed Masked Primes vs. No Primes %%%
    % Plot the delayed masked primes and no primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
    ERP = pop_ploterps( ERP, [7 4], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsNoPrimes_IndivWaves.jpg']);
    close all

    % Plot the delayed masked primes and no primes individual waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [7 4], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsNoPrimes_IndivWaves_AllChans.jpg']);
    close all
  
    % Plot the individual (delayed masked primes and no primes conditions)
    % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
    % non-bipolar channels here)
    ERP = pop_ploterps( ERP, [7 4], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsNoPrimes_ROC.jpg']);
    close all
    
    % Plot the individual (delayed masked primes and no primes conditions)
    % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
    % signal (only ICA-corrected non-bipolar channels here)
    ERP = pop_ploterps( ERP, [7 4], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsNoPrimes_LIO.jpg']);
    close all


    %%% Delayed Visible Primes vs. No Primes %%%
    % Plot the delayed visible primes and no primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
    ERP = pop_ploterps( ERP, [8 4], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelVisPrimesvsNoPrimes_IndivWaves.jpg']);
    close all

    % Plot the delayed visible primes and no primes individual waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [8 4], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelVisPrimesvsNoPrimes_IndivWaves_AllChans.jpg']);
    close all
  
    % Plot the individual (delayed visible primes and no primes conditions)
    % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
    % non-bipolar channels here)
    ERP = pop_ploterps( ERP, [8 4], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelVisPrimesvsNoPrimes_ROC.jpg']);
    close all
    
    % Plot the individual (delayed visible primes and no primes conditions)
    % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
    % signal (only ICA-corrected non-bipolar channels here)
    ERP = pop_ploterps( ERP, [8 4], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelVisPrimesvsNoPrimes_LIO.jpg']);
    close all
    

    %%% Delayed Masked Primes vs. Delayed Visible Primes %%%
    % Plot the delayed masked primes and delayed visible primes individual waveforms at the key electrode sites of interest (F7, FC5, C5, CP5, O1, Pz, Fz, F8, FC6, Cz, C6, CP6, O2)
    ERP = pop_ploterps( ERP, [7 8], [7 9 14 17 27 31 38 42 44 48 51 54 64] , 'Box', [4 4], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsDelVisPrimes_IndivWaves.jpg']);
    close all

    % Plot the delayed masked primes and delayed visible primes individual waveforms at all electrode sites
    ERP = pop_ploterps( ERP, [7 8], [1:67] , 'Box', [8 9], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsDelVisPrimes_IndivWaves_AllChans.jpg']);
    close all
   
    % Plot the individual (delayed masked primes and delayed visible primes conditions)
    % ICA-corrected and uncorrected bipolar HEOG signals (only ICA-corrected
    % non-bipolar channels here)
    ERP = pop_ploterps( ERP, [7 8], [67] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_HEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsDelVisPrimes_ROC.jpg']);
    close all
    
    % Plot the individual (delayed masked primes and delayed visible primes conditions)
    % ICA-corrected monopolar VEOG signals and corrected bipolar VEOG
    % signal (only ICA-corrected non-bipolar channels here)
    ERP = pop_ploterps( ERP, [7 8], [66] , 'Box', [1 2], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_VEOG);
    saveas(gcf,[Subject_Path 'graphs' filesep SUB{i} '_DelMaskedPrimesvsDelVisPrimes_LIO.jpg']);
    close all

%End subject loop
end

%*************************************************************************************************************************************
