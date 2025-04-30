% Written by Ashlie Pankonin July 2024
% Operates on individual subject data
% The order in which participants completed the word and picture portions
% of this study were counterbalanced. In the previous script, the data
% continously collected across both portions was separated into portion 1
% and portion 2. This script renames the portions according to which list
% they completed in each portion.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Users/ashliepankonin/Documents/SDSU-UCSD JDP LCD/PADLD (Dissertation Study)/PADLD Data/EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = { '010224-BS-PADLD' };
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects that require separate processing (study sessions split across 2 files): '032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects that completed the word list first:'010224-BS-PADLD','013024-LK-PADLD','013024-TR-PADLD','030624-LG-PADLD','030924-HCR-PADLD','031324-AH-PADLD','032424-JV-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','050624-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-RH-PADLD','120423-ND-PADLD','122023-ZG-PADLD','122923-JM-PADLD','122923-MS-PADLD', %'032824-RG-PADLD',
% Subjects that completed the picture list first:'011824-VA-PADLD','013024-PR-PADLD','030624-CG-PADLD','030924-HGR-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032824-JG-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050724-AF-PADLD','102623-HJ-PADLD','110123-AN-PADLD','111023-JH-PADLD','112423-AD-PADLD','120623-RH-PADLD','122923-AS-PADLD','122923-TM-PADLD', % '032924-JC-PADLD','041524-JH-PADLD',
% Renamed subjects:'010224-BS-PADLD','013024-LK-PADLD','013024-TR-PADLD','030624-LG-PADLD','030924-HCR-PADLD','031324-AH-PADLD','032424-JV-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','050624-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-RH-PADLD','120423-ND-PADLD','122023-ZG-PADLD','122923-JM-PADLD','122923-MS-PADLD', '011824-VA-PADLD','013024-PR-PADLD','030624-CG-PADLD','030924-HGR-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032824-JG-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050724-AF-PADLD','102623-HJ-PADLD','110123-AN-PADLD','111023-JH-PADLD','112423-AD-PADLD','120623-RH-PADLD','122923-AS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

% Specify which list was completed first and which was completed second
portion1 = 'word';
portion2 = 'picture';

%***********************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)
    
    % Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of
    % current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load portion 1 dataset
    EEG = pop_loadset( 'filename', [SUB{i} '_ICAR_interp_reref_portion1.set'], 'filepath', Subject_Path);
    %EEG = pop_loadset( 'filename', [SUB{i} ' (picture)_ICAR_interp_reref.set'], 'filepath', Subject_Path);
    
    % Save dataset with new name specifying whether data came from the word or picture portion
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '-' portion1 '_ICAR_interp_reref'], 'savenew', [Subject_Path SUB{i} '-' portion1 '_ICAR_interp_reref.set'], 'gui', 'on');
    
    % Load portion 2 dataset
    EEG = pop_loadset( 'filename', [SUB{i} '_ICAR_interp_reref_portion2.set'], 'filepath', Subject_Path);
    %EEG = pop_loadset( 'filename', [SUB{i} ' (word)_ICAR_interp_reref.set'], 'filepath', Subject_Path);
    
    % Save dataset with new name specifying whether data came from the word or picture portion
    [ALLEEG, EEG, CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '-' portion2 '_ICAR_interp_reref'], 'savenew', [Subject_Path SUB{i} '-' portion2 '_ICAR_interp_reref.set'], 'gui', 'on');
end