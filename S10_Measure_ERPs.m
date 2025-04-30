% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% and July 2024
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms, measures
% the mean amplitude during the time window of the component, and saves a
% separate text file for each measurement in the ERP Measurements folder.
% Note that based on their respective unsusceptibility to high frequency
% noise, mean amplitude is calculated on the averaged ERP waveforms
% *without* a low-pass filter applied.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

% Set portions
portion = 'word'; % 'word','picture'

% Set comparison conditions
compconds = 'masked_and_visible';

% Set measurement time window for measuring mean amplitude in milliseconds (e.g., 300 to 500 ms)
timewindow = [300 500];

% Set EEG channel(s) to measure the components
chan = [8	9	10	11	12	13	17	18	19	20	21	22	26	27	28	29	30	31	35	36	37	38	39	40	44	45	46	47	48	49];

% Set difference wave bin(s) for measurement
diffbin = [44 45 46 47];  

% Set parent wave bins for measurement
parentbins = [19    20	23	24	27	28	31	32];  

% Set baseline correction period for measurement
baselinecorr = [-50 50]; 

%*************************************************************************************************************************************

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
% 
% % Parent waveform measurements on averaged ERP waveforms without a low-pass
% % filter applied
% 
% % Create a text file containing a list of unfiltered ERP sets and their file
% % locations to measure mean amplitude from
% ERPset_list = fullfile([DIR filesep 'ERP Measurements' filesep], [portion '_measurement_ERP_list_50prepostbl_clusterchannels.txt']);
% fid = fopen(ERPset_list, 'w');
%     for i = 1:length(SUB)
%         Subject_Path = [DIR filesep SUB{i} filesep];
%         erppath = [Subject_Path SUB{i} '-' portion '_erp.erp'];
%         fprintf(fid,'%s\n', erppath);
%     end
% fclose(fid);
% 
% % Measure mean amplitude using the time window, channel(s), and bin(s)
% % specified above
% ALLERP = pop_geterpvalues( ERPset_list, timewindow, parentbins, chan, 'Baseline', baselinecorr, 'Measure', 'meanbl', 'Filename',... 
%     [DIR filesep 'ERP Measurements' filesep portion '_' compconds '_mean_amplitudes_50prepostbl_clusterchannels.txt'], 'Binlabel', 'on', 'FileFormat', 'wide', 'InterpFactor',  1,  'Resolution', 3);

%*************************************************************************************************************************************

% Difference waveform measurements on averaged ERP waveforms without a
% low-pass filter applied

% Create a text file containing a list of unfiltered ERP sets and their file
% locations to measure mean amplitude from
ERPset_list = fullfile([DIR filesep 'ERP Measurements' filesep], [portion '_measurement_ERP_list_50prepostbl_clusterchannels.txt']);
fid = fopen(ERPset_list, 'w');
    for i = 1:length(SUB)
        Subject_Path = [DIR filesep SUB{i} filesep];
        erppath = [Subject_Path SUB{i} '-' portion '_erp_diffwaves.erp'];
        fprintf(fid,'%s\n', erppath);
    end
fclose(fid);
% Measure mean amplitude using the time window, channel(s), and bin(s)
% specified above
ALLERP = pop_geterpvalues( ERPset_list, timewindow, diffbin, chan, 'Baseline', baselinecorr, 'Measure', 'meanbl',... 
    'Filename', [DIR filesep 'ERP Measurements' filesep portion '_' compconds '_mean_amplitudes_50prepostbl_clusterchannels_diffwaves.txt'], 'Binlabel', 'on', 'FileFormat', 'wide',... 
    'InterpFactor',  1,  'Resolution', 3);

%*************************************************************************************************************************************