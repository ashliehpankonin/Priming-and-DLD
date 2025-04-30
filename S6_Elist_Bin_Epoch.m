% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021 &
% July 2024
% Operates on individual subject data This script loads the ICA-corrected
% continuous EEG data file with the transferred ICA weights, creates an Event
% List containing a record of all event codes and their timing, assigns
% events to bins using Binlister, epochs the EEG, and performs baseline
% correction.

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
% Epoched subjects: '010224-BS-PADLD', '011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

% List of portions to process
portion = {'picture','word'};
%**********************************************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    for p = 1:length(portion)

        % Open EEGLAB and ERPLAB Toolboxes  
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        
        % Define subject path based on study directory and subject ID of current subject
        Subject_Path = [DIR filesep SUB{i} filesep];
    
        % Load the interpolated, referenced, and split-by-portion continuous EEG data file in .set EEGLAB file format
        EEG = pop_loadset( 'filename', [SUB{i} '-' portion{p} '_ICAR_interp_reref.set'], 'filepath', Subject_Path);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '-' portion{p} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp_reref'], 'gui', 'off'); 
    
        % Create EEG Event List containing a record of all event codes and their timing
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', [Subject_Path SUB{i} '_Eventlist.txt'] ); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '-' portion{p} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp_reref_elist'], 'savenew', [Subject_Path SUB{i} '-' portion{p} '_ICAR_interp_reref_elist.set'], 'gui', 'off');
    
        % Assign events to bins with Binlister; an individual trial may be assigned to more than one bin (bin assignments can be reviewed in each subject's N400_Eventlist_Bins.txt file)
        EEG  = pop_binlister( EEG , 'BDF', [DIR filesep 'PADLD_bins.txt'], 'ExportEL', [Subject_Path SUB{i} '-' portion{p} '_Eventlist_Bins.txt'], 'IndexEL',  1, 'SendEL2', 'EEG&Text', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '-' portion{p} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp_reref_elist_bins'], 'savenew', [Subject_Path SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins.set'], 'gui', 'off'); 
    
        % Epoch the EEG into 1-second segments time-locked to the response (from -100 ms to 800 ms) and perform baseline correction using the average activity from -100 ms to 0 ms 
        EEG = pop_epochbin( EEG , [-100.0  800.0],  [-100.0  0.0]);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '-' portion{p} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp_reref_elist_bins_epoch'], 'savenew', [Subject_Path SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins_epoch.set'], 'gui', 'off'); 
        close all;
    % End portion loop
    end
% End subject loop
end

%**********************************************************************************************************************************************************************
