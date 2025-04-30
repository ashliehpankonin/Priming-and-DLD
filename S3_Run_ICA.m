% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin September
% 2021 and July 2024
% Operates on individual subject data
% This script loads the prepped-for-ICA semi-continuous EEG data file
% (i.e., with the break periods and noisy segments of EEG removed),
% computes the ICA weights that will be used for artifact correction of
% ocular artifacts, transfers the ICA weights to the continuous EEG data
% file without the break periods and noisy segments of EEG removed, and
% saves the topographic maps of the ICA weights for later review.

% PLEASE NOTE: The results of ICA decomposition using binica/runica (i.e.,
% the ordering of the components, the scalp topographies, and the time
% courses of the components) will differ slightly each time ICA weights are
% computed. This is because ICA decomposition starts with a random weight
% matrix (and randomly shuffles the data order in each training step), so
% the convergence is slightly different every time it is run.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects that require separate processing (study sessions split across 2 files): '032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% ICA-ed subjects: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

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

    % Load the prepped-for-ICA semi-continuous EEG data file in .set EEGLAB
    % file format
    EEG = pop_loadset( 'filename', [SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep.set'], 'filepath', Subject_Path); 
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep'], 'gui', 'off'); 

    % Compute ICA weights with binICA (a compiled and faster version of
    % ICA). If binICA is not an option (e.g., on a Windows machine), use
    % runICA by replacing the code with the following: 
    % EEG = pop_runica(EEG,'extended',1,'chanind', [1:31])
    % Any channels that are not linearly independent (i.e., interpolated
    % channels, bipolar EOG channels) and any channels that will be
    % interpolated at a later step are not included in the channel list for
    % computing ICA weights.
    % Channel(s) not to include are specified in Excel file Interpolate_Channels.xls
    DimensionsOfFile1 = size(alldata1);  
    for j = 1:DimensionsOfFile1(1);
        if isequal([SUB{i}],num2str(alldata1{j,1}));
           badchans = (alldata1{j,2});
           if ~isequal(badchans,'none') | ~isempty(badchans)
           	  if ~isnumeric(badchans)
                 badchans = str2num(badchans);
                 goodchans = [1:63];
                 %disp (goodchans)
                 %EEG = pop_runica(EEG,'extended',1,'icatype','binica','chanind',goodchans); 
                 EEG = pop_runica(EEG,'extended',1,'chanind',goodchans); 
              end
             allchans = [1:63];
             goodchans = allchans(~ismember(allchans,badchans));
             %disp (goodchans)
             %EEG = pop_runica(EEG,'extended',1,'icatype','binica','chanind',goodchans); 
             EEG = pop_runica(EEG,'extended',1,'chanind',goodchans);
           end
        end
    end
    %disp(goodchans)
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep_icaweights'], 'savenew', [Subject_Path SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep_icaweights.set'], 'gui', 'off');
    eeglab redraw;

    % Load the continuous EEG data file without the break periods and noisy
    % segments of data removed in .set EEGLAB file format
    %EEG = pop_loadset( 'filename', [SUB{i} '_ds_chanupdate_bpfilt.set'], 'filepath', Subject_Path);
    %[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '_ds_chanupdate_bpfilt'], 'gui', 'off'); 
    STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];
    EEG = pop_loadset( 'filename', [SUB{i} '_ds_chanupdate_bpfilt.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
    
    % Load the prepped-for-ICA semi-continuous EEG data file in .set EEGLAB
    % file format again (to ensure the files are ordered for correct
    % transfer of ICA weights)
    EEG = pop_loadset( 'filename', [SUB{i} '_ds_chanupdate_bpfiltx2_100hzrs_nobreaks_icaprep_icaweights.set'], 'filepath', Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );

    % Transfer ICA weights to the continuous EEG data file without the
    % break periods and noisy segments of data removed and save that as a
    % new EEG data file
    %EEG = pop_editset(EEG, 'icaweights', 'ALLEEG(2).icaweights', 'icasphere', 'ALLEEG(2).icasphere', 'icachansind', 'ALLEEG(2).icachansind');
    %[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '_ds_chanupdate_bpfilt_icaweighted'], 'savenew', [Subject_Path SUB{i} '_ds_chanupdate_bpfilt_icaweighted.set'], 'gui', 'off');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
    EEG = pop_editset(EEG, 'icaweights', 'ALLEEG(2).icaweights', 'icasphere', 'ALLEEG(2).icasphere', 'icachansind', 'ALLEEG(2).icachansind');
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_saveset( EEG, 'filename',[SUB{i} '_ds_chanupdate_bpfilt_icaweighted.set'],'filepath',Subject_Path);
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_editset(EEG, 'setname', [SUB{i} '_ds_chanupdate_bpfilt_icaweighted']);
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_saveset( EEG, 'savemode','resave');
    [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, CURRENTSET);
    eeglab redraw;

    % Save a jpg of the topographic maps of the ICA weights for later review
    set(groot,'DefaultFigureColormap',jet)
    pop_topoplot(EEG, 0, 1:size(EEG.icaweights,1),[SUB{i} ' ICA Component Maps in 2D (aka Scalp Maps)'], 0,'electrodes','on');
    saveas(gcf,[Subject_Path filesep SUB{i} ' ICA Scalp Maps.jpg'])    
    close all

%End subject loop
end

%***********************************************************************************************************************************************
