% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin July 2024
% Operates on individual subject data 
% Uses the output from S1_Preprocess_Raw_Data.m
% This script loads the outputted continuous EEG data file from S1, removes
% segments of EEG during the break periods in between trial blocks, and
% removes especially noisy segments of EEG during the trial blocks to
% prepare the data for ICA. Note that the goal of this stage of processing
% is to remove particularly noisy segments of data; a more thorough
% rejection of artifacts will be performed later on the epoched data.

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
% ICA-prepped subjects: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

%*************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the continuous EEG data file outputted from S1 in .set EEGLAB file format
    EEG = pop_loadset( 'filename', [SUB{i} '_ds_chanupdate_bpfilt.set'], 'filepath', Subject_Path);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_ds_chanupdate_bpfilt'], 'gui', 'off'); 
    
    % Apply a stronger band-pass filter (rx half-amplitude cutoffs at 1 and
    % ≤30 Hz with 48 dB/octave roll-off)
    EEG  = pop_basicfilter( EEG,  1:EEG.nbchan , 'Boundary', 'boundary', 'Cutoff', [ 1 10], 'Design', 'butter', 'Filter', 'bandpass', 'Order',  8,...
 'RemoveDC', 'on' );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[SUB{i} '_ds_chanupdate_bpfiltx2'],'savenew',[Subject_Path SUB{i} '_ds_chanupdate_bpfiltx2.set'] ,'gui','off'); 

    % Resample the data to 100 Hz to speed data processing
    EEG = pop_resample( EEG, 100);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs'],'savenew',[Subject_Path SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs.set'] ,'gui','off'); 
    
    % Remove segments of EEG during the break periods in between trial blocks (defined as 2 seconds or longer in between successive stimulus event codes)
    EEG  = pop_erplabDeleteTimeSegments( EEG , 'displayEEG', 0, 'endEventcodeBufferMS',  2000, 'ignoreUseEventcodes', [1 2 9 111 128 -3840 -3839.9999 99], 'ignoreUseType', 'Ignore', 'startEventcodeBufferMS',  2000, 'timeThresholdMS',  2000 );
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks'], 'savenew', [Subject_Path SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks.set'], 'gui', 'off'); 

    % Load parameters for rejecting especially noisy segments of EEG during trial blocks from Excel file ICA_Prep_Values_N400.xls. Default parameters can be used initially but may need 
    % to be modified for a given participant on the basis of visual inspection of the data.
    [ndata, text, alldata] = xlsread([DIR filesep 'ICA_Prep_Values']); 
        for j = 1:length(alldata)           
            if isequal(SUB{i} ,num2str(alldata{j,1}));
                AmpthValue = alldata{j,2};
                WindowValue = alldata{j,3};
                StepValue = alldata{j,4};
            end
        end

    % Delete segments of the EEG exceeding the thresholds defined above
    % excluding EOG channels
    EEG = pop_continuousartdet( EEG, 'ampth', AmpthValue, 'winms', WindowValue, 'stepms', StepValue, 'chanArray', 1:62, 'review', 'off');        
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep'], 'savenew', [Subject_Path SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep.set'], 'gui', 'off'); 

% End subject loop
end

%*************************************************************************************************************************************
