% Written by Ashlie Pankonin March 2021 and modified July 2024
% Operates on individual subject data 
% Because most participants completed the word and picture portion of this
% study in one sitting, each of which included practice trials, test
% trials, and prime visibility threshold trials, and the EEG data was
% recorded continuously throughout all of that, we need to separate the EEG
% data into their respective portions for future analyses. The beginning of
% each study portion/practice trials set is marked by an event code of 9,
% the beginning of each study portions's test trials set is marked by an
% event code of 99, the end of each study portion's test trials set/the
% beginning of each study portion's prime visibility threshold trials set
% is marked with an event code of 255, and the end of each study
% portion/prime visibility threshold trials set is marked by an event code
% of 111. Each of these event codes should only occur twice (once per
% portion), but it's possible that is not the case. This script checks to
% see whether there are any instances where the specified EEG event codes
% occur less/more frequently than expected (listed in EEG.event.type data
% structure).
% Note that after removing extra event codes, all the event codes are
% stored as a single, concatenated value and this script will no longer
% return the accurate number of occurrences of any event code. You must
% manually check the number of occurrences of event codes for those files.

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% Create a text file to store the results
fileID = fopen('/Volumes/Life Support/PADLD/event_code_counts.txt', 'w');

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD',};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects that require separate processing (study sessions split across 2 files): '032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

% List of event codes to check
targetEventCodes = [9, 99, 111, 255];

% Initialize a matrix to store counts for each participant
numParticipants = length(SUB);
countsMatrix = zeros(numParticipants, length(targetEventCodes));

%***********************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    % Open EEGLAB and ERPLAB Toolboxes
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of current subject
    Subject_Path = [DIR filesep SUB{i} filesep];
    
    % Load dataset
    EEG = pop_loadset('filename',[SUB{i} '_ICAR_interp_reref.set'],'filepath',Subject_Path);
    
    % Extract event types from EEG data
    eventTypes = [EEG.event.type];
    
    % Count occurrences of each target event code
    for t = 1:length(targetEventCodes)
        countsMatrix(i, t) = sum(eventTypes == targetEventCodes(t));
    end
end

% Write the header
fileID = fopen('/Volumes/Life Support/PADLD/event_code_counts.txt','a');
fprintf(fileID, 'Participant\t');
for t = 1:length(targetEventCodes)
    fprintf(fileID, 'EventCode_%d\t', targetEventCodes(t));
end
fprintf(fileID, '\n');

% Write the counts for each participant
for i = 1:numParticipants
    fprintf(fileID, '%s\t', SUB{i});
    for t = 1:length(targetEventCodes)
        fprintf(fileID, '%d\t', countsMatrix(i, t));
    end
    fprintf(fileID, '\n');
end

% Close the file
fclose(fileID);

fprintf('Event counts have been saved to %s.\n', 'event_code_counts.txt');
