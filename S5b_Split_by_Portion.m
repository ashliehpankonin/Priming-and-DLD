% Written by Diego Leon and Ashlie Pankonin July 2024
% Operates on individual subject data
% Because most participants completed the word and picture portion of this
% study in one sitting and the EEG data was recorded continuously
% throughout both of those portions, we need to separate the EEG data into
% their respective portions for future analyses. This script splits the
% continuous file into the two portions.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Users/ashliepankonin/Documents/SDSU-UCSD JDP LCD/PADLD (Dissertation Study)/PADLD Data/EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'010224-BS-PADLD'};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects that require separate processing (study sessions split across 2 files): '032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Split subjects: '032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD','010224-BS-PADLD', '031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD',

%***********************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)
    
    % Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of
    % current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load interpolated and rereferenced continuous EEG data file in .set EEGLAB file format
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset( 'filename', [SUB{i} '_ICAR_interp_reref.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % Extract event types from EEG data
    eventTypes = [EEG.event.type];
    
    % Find the indices of the event codes 99 and 255
    [~, start_event_indices] = eeg_getepochevent(EEG,{99});
    [~, end_event_indices] = eeg_getepochevent(EEG,{255});

    % Split up the indice arrays
    start_event_indices = cell2mat(start_event_indices);
    end_event_indices = cell2mat(end_event_indices);
    
    % Ensure there are equal numbers of start and end events
    if length(start_event_indices) ~= length(end_event_indices)
        error('Mismatch between the number of start and end events.');
    end
    
    % Loop through each pair of start and end events and extract the data
    for j = 1:length(start_event_indices)
        start_idx = ((start_event_indices(j)/1000)-1);
        end_idx = ((end_event_indices(j)/1000)+1);
        
        % Extract the data from the specified indices
        EEG = pop_select(EEG, 'time', [start_idx end_idx]);

        portionnumber = num2str(j);
        
        % Save the segment data to a new file
        EEG = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp_reref_portion' portionnumber], 'savenew', [Subject_Path SUB{i} '_ICAR_interp_reref_portion' portionnumber '.set'], 'gui', 'off');

        if j == 1
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
        end
    end
end

disp('Continuous EEG data split by portions and saved successfully.');
