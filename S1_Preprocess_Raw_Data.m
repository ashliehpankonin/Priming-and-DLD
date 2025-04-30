% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin July 2024
% Operates on individual subject data
% This script imports raw continuous EEG data files and returns the data in
% .set EEGLAB file format, shifts the stimulus event codes forward in time
% to account for the LCD monitor delay, downsamples the data to speed data
% processing time, creates bipolar ocular channels, adds channel location
% information, removes the DC offsets, and applies a band-pass filter.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects that require separate processing (study sessions split across 2 files): '032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Preprocessed subjects: '010224-BS-PADLD','011824-VA-PADLD''013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

%***********************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % If .set EEGLAB file format of raw continuous EEG data does not exist, import file and convert it
    if ~exist([Subject_Path SUB{i} '.set'])
        EEG = loadcurry([Subject_Path SUB{i} '.dap'], 'KeepTriggerChannel', 'False', 'CurryLocations', 'False');
        % Optional Parameters: 
        % 1     'CurryLocations' - Boolean parameter
        % to determine if the sensor locations are carried forward
        % from Curry [1, 'True'] or if the channel locations from
        % EEGLAB should be used [0, 'False' Default].
        % 2     'KeepTriggerChannel' - Boolean parameter to determine if
        % the trigger channel is retained in the array [1, 'True' Default]
        % or if the trigger channel should be removed [0, 'False']. I 
        % debated adjusting this parameter but given the EEGLAB/ERPLAB bugs
        % associated with trigger events, this provides a nice data check. 
        % You can always delete the channel or relocate it later.
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i}], 'savenew', [Subject_Path SUB{i} '.set'], 'gui', 'off');
    % Otherwise, load the .set file
    else 
        EEG = pop_loadset( 'filename', [SUB{i} '.set'], 'filepath', Subject_Path);
    end

    % Shift the stimulus event codes forward in time to account for the LCD
    % monitor delay (TBD, should be measured with a photosensor)
    %EEG  = pop_erplabShiftEventCodes( EEG , 'DisplayEEG', 0, 'DisplayFeedback', 'summary', 'Eventcodes', [111 112 121 122 211 212 221 222], 'Rounding', 'earlier', 'Timeshift',  26 );
    %[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname', [SUB{i} '_shifted'],'savenew',[Subject_Path SUB{i} '_N400_shifted.set'] ,'gui','off'); 

    % Downsample from the recorded sampling rate to speed data processing
    % (automatically applies the appropriate low-pass anti-aliasing filter)
    EEG = pop_resample( EEG, 500);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[SUB{i} '_ds'],'savenew',[Subject_Path SUB{i} '_ds.set'] ,'gui','off'); 
    
    % Create bipolar ocular channel(s; e.g., bipolar HEOG channel =
    % HEOG_left - HEOG_right; bipolar left VEOG channel = VEOG_lower - FP1)
    EEG = pop_eegchanoperator( EEG, {'ch67 = (ch65 - ch1) Label (uncorr) VEOG'}, 'Saveas', 'off');

    % Remove unused channels
    EEG = pop_select(EEG, 'nochannel', {'M1' 'M2' 'HEO'});
    
    % Add channel location information corresponding to the 3-D coordinates
    % of the electrodes based on 10-20 International System site locations
    EEG=pop_chanedit(EEG, 'load',{[DIR filesep 'SynAmps2-Nuevo Quik-Cap64.loc'],'filetype','loc'});
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '_ds_chanupdate'], 'savenew', [Subject_Path SUB{i} '_ds_chanupdate.set'], 'gui', 'off');

    % Remove DC offsets and apply a band-pass filter 
    % Per Zhang et al. (2024), the rx filter settings when analyzing N400
    % mean amplitudes are a non-causal Butterworth impulse response
    % function with a 0.2 Hz high-pass filter, ≥10 Hz or no low-pass
    % filter, and a 12 dB/oct roll-off (for noisier data, there is a small
    % benefit to applying a 5 or 10 Hz low pass filter)
    EEG = pop_basicfilter( EEG,  1:EEG.nbchan, 'Boundary', 'boundary', 'Cutoff', [ 0.2 10], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  2,...
 'RemoveDC', 'on' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_ds_chanupdate_bpfilt'], 'savenew', [Subject_Path SUB{i} '_ds_chanupdate_bpfilt.set'], 'gui', 'off');

%End subject loop
end

%***********************************************************************************************************************************************
