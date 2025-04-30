% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% and July 2024
% Operates on data averaged across participants
% This script loads the low-pass filtered grand average ERP waveforms,
% plots the grand average waveforms and saves .jpg files of all of the
% plots in the grand average ERPs folder.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'101923-DV-PADLD',	'102623-HJ-PADLD',	'110123-AN-PADLD',	'110123-BN-PADLD',	'110123-CB-PADLD',	'111023-JH-PADLD',	'111023-RH-PADLD',	'120423-ND-PADLD',	'120623-RH-PADLD',	'122023-ZG-PADLD',	'122923-JM-PADLD',	'122923-TM-PADLD',	'122923-MS-PADLD',	'011824-VA-PADLD',	'013024-LK-PADLD',	'013024-PR-PADLD',	'030624-LG-PADLD',	'030624-CG-PADLD',	'030924-HCR-PADLD',	'030924-HGR-PADLD',	'031324-AH-PADLD',	'031324-ZH-PADLD',	'031924-LC-PADLD',	'032824-JG-PADLD',	'032824-RG-PADLD',	'032824-SG-PADLD',	'032924-JC-PADLD',	'040124-CP-PADLD',	'042524-NH-PADLD',	'050624-AF-PADLD',	'050724-AF-PADLD',	'050924-EL-PADLD',};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% DLD subjects:'112423-AD-PADLD',	'122923-AS-PADLD',	'010224-BS-PADLD',	'013024-TR-PADLD',	'032424-JV-PADLD',	'040824-LH-PADLD',	'040924-EK-PADLD',	'041524-JH-PADLD',	'042524-DH-PADLD',
% TL subjects: '101923-DV-PADLD',	'102623-HJ-PADLD',	'110123-AN-PADLD',	'110123-BN-PADLD',	'110123-CB-PADLD',	'111023-JH-PADLD',	'111023-RH-PADLD',	'120423-ND-PADLD',	'120623-RH-PADLD',	'122023-ZG-PADLD',	'122923-JM-PADLD',	'122923-TM-PADLD',	'122923-MS-PADLD',	'011824-VA-PADLD',	'013024-LK-PADLD',	'013024-PR-PADLD',	'030624-LG-PADLD',	'030624-CG-PADLD',	'030924-HCR-PADLD',	'030924-HGR-PADLD',	'031324-AH-PADLD',	'031324-ZH-PADLD',	'031924-LC-PADLD',	'032824-JG-PADLD',	'032824-RG-PADLD',	'032824-SG-PADLD',	'032924-JC-PADLD',	'040124-CP-PADLD',	'042524-NH-PADLD',	'050624-AF-PADLD',	'050724-AF-PADLD',	'050924-EL-PADLD',

% Set portion
portion = 'word'; %'picture','word'

% Set baseline correction period in milliseconds
baselinecorr = '-100 0';

% Set x-axis scale in milliseconds
xscale = [-100.0 800.0   -100:100:800];

% Set y-axis scale in microvolts for the EEG channels for the waves
yscale_EEG_parent = [-3.5 3.5   -3.5:1.25:3.5]; %[-10.0 15.0   -10:5:15];

% Set participant group
participantgroup = 'All'; %'All', 'DLD', 'TL'

% Set comparison conditions
compconds = 'MaskedWord';

%*************************************************************************************************************************************

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Load the low-pass filtered grand average ERP waveforms in .erp ERPLAB
% file format        
ERP = pop_loaderp('filename', [participantgroup '_' portion '_GA_ERPs_20hzlpfilt.erp'], 'filepath', [DIR filesep 'Grand Average ERPs' filesep participantgroup ' Participants'] );    

% Plot the grand average waveforms of the specified bins at the specified electrode sites
ERP = pop_ploterps( ERP, [19	20	23	24], [1	2	3	4	5	8	10	12	17	19	21	24	26	28	30	32	35	37	39	44	46	48	53	54	55	59	60	61] , 'Box', [4 7], 'blc', baselinecorr, 'Maximize', 'on', 'Style', 'Classic', 'xscale', xscale,  'yscale', yscale_EEG_parent);
saveas(gcf,[DIR filesep 'Grand Average ERPs' filesep participantgroup ' Participants' filesep participantgroup '_GA_' compconds '_Waves_20hzlpfilt.jpg']);
close all

%*************************************************************************************************************************************
