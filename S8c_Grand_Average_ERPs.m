% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% and July 2024
% Operates on individual subject data
% This script uses the individual subject averaged ERP waveforms to create
% grand average ERP waveforms across participants both with and without a
% low-pass filter applied.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'101923-DV-PADLD',	'110123-AN-PADLD',	'110123-BN-PADLD',	'110123-CB-PADLD',	'111023-JH-PADLD',	'111023-RH-PADLD',	'120423-ND-PADLD',	'120623-RH-PADLD',	'122023-ZG-PADLD',	'122923-JM-PADLD',	'122923-TM-PADLD',	'122923-MS-PADLD',	'011824-VA-PADLD',	'013024-LK-PADLD',	'013024-PR-PADLD',	'030624-LG-PADLD',	'030624-CG-PADLD',	'030924-HCR-PADLD',	'030924-HGR-PADLD',	'031324-AH-PADLD',	'031324-ZH-PADLD',	'031924-LC-PADLD',	'032824-JG-PADLD',	'032824-RG-PADLD',	'032824-SG-PADLD',	'032924-JC-PADLD',	'040124-CP-PADLD',	'042524-NH-PADLD',	'050624-AF-PADLD',	'050724-AF-PADLD',	'050924-EL-PADLD',};
% Entire subject list: '102623-HJ-PADLD','010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% DLD subjects:'112423-AD-PADLD','122923-AS-PADLD','010224-BS-PADLD','013024-TR-PADLD',	'032424-JV-PADLD',	'040824-LH-PADLD',	'040924-EK-PADLD',	'041524-JH-PADLD',	'042524-DH-PADLD',
% TL subjects: '102623-HJ-PADLD','101923-DV-PADLD',	'110123-AN-PADLD',	'110123-BN-PADLD',	'110123-CB-PADLD',	'111023-JH-PADLD',	'111023-RH-PADLD',	'120423-ND-PADLD',	'120623-RH-PADLD',	'122023-ZG-PADLD',	'122923-JM-PADLD',	'122923-TM-PADLD',	'122923-MS-PADLD',	'011824-VA-PADLD',	'013024-LK-PADLD',	'013024-PR-PADLD',	'030624-LG-PADLD',	'030624-CG-PADLD',	'030924-HCR-PADLD',	'030924-HGR-PADLD',	'031324-AH-PADLD',	'031324-ZH-PADLD',	'031924-LC-PADLD',	'032824-JG-PADLD',	'032824-RG-PADLD',	'032824-SG-PADLD',	'032924-JC-PADLD',	'040124-CP-PADLD',	'042524-NH-PADLD',	'050624-AF-PADLD',	'050724-AF-PADLD',	'050924-EL-PADLD',
% Exclude '102623-HJ-PADLD' from picture GAs (> 50% of epochs rejected)

% List of portions to process
portion = {'picture'}; % 'picture','word'

%*************************************************************************************************************************************

% Create grand average ERP waveforms from individual subject ERPs *WITHOUT* low-pass filter applied 

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for p = 1:length(portion)

    % Create a text file containing a list of ERPsets and their file locations to include in the grand average ERP waveforms
    ERPset_list = fullfile(DIR, ['TL_' portion{p} '_GA_ERPs.txt']);
    fid = fopen(ERPset_list, 'w');
        for i = 1:length(SUB)
            Subject_Path = [DIR filesep SUB{i} filesep];
            erppath = [Subject_Path SUB{i} '-' portion{p} '_erp.erp'];
            fprintf(fid,'%s\n', erppath);
        end
    fclose(fid);

    % Create a grand average ERP waveform
    ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', ['TL_' portion{p} '_GA_ERPs'], 'filename', ['TL_' portion{p} '_GA_ERPs.erp'], 'filepath', DIR, 'Warning', 'off');

% End portion loop
end
%*************************************************************************************************************************************

% Create grand average ERP waveforms from individual subject ERPs *WITH* a low-pass filter applied

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

for p = 1:length(portion)
    
    % Create a text file containing a list of low-pass filtered ERPsets and
    % their file locations to include in the grand average ERP waveforms
    ERPset_list = fullfile(DIR, ['TL_' portion{p} '_GA_ERPs.txt']);
    fid = fopen(ERPset_list, 'w');
        for i = 1:length(SUB)
            Subject_Path = [DIR filesep SUB{i} filesep];
            erppath = [Subject_Path SUB{i} '-' portion{p} '_erp_20hzlpfilt.erp'];
            fprintf(fid,'%s\n', erppath);
        end
    fclose(fid);
    
    % Create a grand average ERP waveform
    ERP = pop_gaverager( ERPset_list , 'ExcludeNullBin', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname', ['TL_' portion{p} '_GA_ERPs_20hzlpfilt'], 'filename', ['TL_' portion{p} '_GA_ERPs_20hzlpfilt.erp'], 'filepath', DIR, 'Warning', 'off');

    % End portion loop
end
%*************************************************************************************************************************************
