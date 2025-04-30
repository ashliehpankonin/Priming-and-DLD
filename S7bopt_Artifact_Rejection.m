% Written by Ashlie Pankonin July 2024
% Operates on individual subject data
% This script loads the epoched EEG data file that has undergone artifact
% detection and rejects the epochs that are marked as containing artifacts
% (i.e., marked for rejection).

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects with epochs rejected: '010224-BS-PADLD'
% ,'011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD',

% List of portions to process
portion = {'picture','word'};

%**********************************************************************************************************************************************************************

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%Loop through each subject listed in SUB
for i = 1:length(SUB)

     for p = 1:length(portion)
  
        % Define subject path based on study directory and subject ID of current subject
        Subject_Path = [DIR filesep SUB{i} filesep];
    
        % Load the epoched and artifact detected EEG data file outputted from S7 in .set EEGLAB file format
        EEG = pop_loadset( 'filename', [SUB{i} '-' portion{p} '_allAR.set'], 'filepath', Subject_Path);
        
        % Reject the epochs that are marked for rejection
        EEG = pop_rejepoch( EEG, EEG.reject.rejmanual,1);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '-' portion{p} '_allAR_epochsrej'], 'savenew', [Subject_Path SUB{i} '-' portion{p} '_allAR_epochsrej.set'], 'gui', 'on');

    % End portion loop
    end
% End subject loop
end
    