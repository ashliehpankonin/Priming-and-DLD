% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin July 2024
% Operates on individual subject data
% This script loads the ICA-corrected continuous EEG data file with the
% transferred ICA weights, interpolates bad channels listed in Excel
% file Interpolate_Channels.xls, and rereferences the data to the specified
% channels.

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
% Rereferenced and interpolated subjects:'010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD'

% Load the Excel file with the list of channels to interpolate for each subject 
[ndata1, text1, alldata1] = xlsread([DIR filesep 'Interpolate_Channels']);

%***********************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)
    
    % Open EEGLAB and ERPLAB Toolboxes  
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

    % Define subject path based on study directory and subject ID of
    % current subject
    Subject_Path = [DIR filesep SUB{i} filesep];

    % Load the ICA-corrected continuous EEG data file with the transferred ICA weights in .set EEGLAB file format
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset( 'filename', [SUB{i} '_ICAR.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );    
     
    % Interpolate channel(s) specified in Excel file
    % Interpolate_Channels.xls; any channels without channel locations
    % (e.g., the eye channels) or that will later be used for measurement
    % of the ERPs should not be interpolated.
    %ignored_channels = [];        
    DimensionsOfFile1 = size(alldata1);
    for j = 1:DimensionsOfFile1(1);
        if isequal(SUB{i},num2str(alldata1{j,1}));
           badchans = (alldata1{j,2});
           if ~isequal(badchans,'none') | ~isempty(badchans)
           	  if ~isnumeric(badchans)
                 badchans = str2num(badchans);
              end
              EEG  = pop_interp(EEG,badchans, 'spherical');
              % EEG  = pop_erplabInterpolateElectrodes( EEG , 'displayEEG',  0, 'ignoreChannels',  ignored_channels, 'interpolationMethod', 'spherical', 'replaceChannels', badchans);
           end
           [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[SUB{i} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp'],'savenew',[Subject_Path SUB{i} '_ICAR_interp.set'], 'gui', 'off');
        end
    end

    % Rereference dataset to average of TP7 (33) and TP8 (41)
    EEG = pop_eegchanoperator( EEG, [DIR filesep 'Rereference.txt']);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_ds_chanupdate_bpfilt_icaweighted_ICAR_interp_reref'], 'savenew', [Subject_Path SUB{i} '_ICAR_interp_reref.set'],'gui', 'off');
end
