% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% and July 2024
% Operates on individual subject data
% This script loads the epoched EEG data file and performs artifact
% detection to identify and mark for rejection noisy segments of EEG,
% segments containing eyeblinks or eye movements during the time of the
% stimulus (i.e., resulting in a change in sensory input on that trial),
% and segments containing uncorrected residual eye movements throughout the
% epoch using the parameters tailored to an individual subject's data
% listed in the corresponding Excel file for that artifact.

close all; clearvars;

% Location of the folder that contains this script and any associated
% processing files. This should be the main file path that leads you to
% your data. The last file should be the one that houses your subject
% folders.
DIR = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'010224-BS-PADLD' ,'011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'};
% Entire subject list: '010224-BS-PADLD','011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'
% Subjects with AR done: '010224-BS-PADLD' ,'011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'

% List of portions to process
portion = {'picture','word'};

% Load the Excel file with the list of thresholds and parameters for
% identifying C.R.A.P. with the simple voltage threshold algorithm for each
% subject
[ndata2, text2, alldata2] = xlsread([DIR filesep 'AR_Parameters_for_SVT_CRAP']);

% Load the Excel file with the list of thresholds and parameters for
% identifying C.R.A.P. with the moving window peak-to-peak algorithm for
% each subject
[ndata3, text3, alldata3] = xlsread([DIR filesep 'AR_Parameters_for_MW_CRAP']);

% Load the Excel file with the list of thresholds and parameters for
% identifying eyeblinks during the stimulus presentation period (using the
% original non-ICA corrected VEOG signal) with the moving window
% peak-to-peak algorithm for each subject
[ndata4, text4, alldata4] = xlsread([DIR filesep 'AR_Parameters_for_MW_Blinks']);

% % Load the Excel file with the list of thresholds and parameters for
% % identifying horizontal eye movements during the stimulus presentation
% % period (using the original non-ICA corrected HEOG signal) with the step
% % like algorithm for each subject
% [ndata5 text5, alldata5] = xlsread([DIR filesep 'AR_Parameters_for_SL_HEOG_Stim_Pres']);
% 
% % Load the Excel file with the list of thresholds and parameters for
% % identifying any uncorrected horizontal eye movements (using the
% % ICA-corrected HEOG signal) with the step like algorithm for each subject
% [ndata6 text6, alldata6] = xlsread([DIR filesep 'AR_Parameters_for_SL_HEOG']);

%**********************************************************************************************************************************************************************

% Loop through each subject listed in SUB
for i = 1:length(SUB)

    for p = 1:length(portion)

        % Open EEGLAB and ERPLAB Toolboxes  
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        
        % Define subject path based on study directory and subject ID of current subject
        Subject_Path = [DIR filesep SUB{i} filesep];
    
        % Load the epoched EEG data file in .set EEGLAB file format
        EEG = pop_loadset( 'filename', [SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins_epoch.set'], 'filepath', Subject_Path);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0, 'setname', [SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins_epoch'], 'gui', 'on'); 
    
        % Identify segments of EEG with C.R.A.P. artifacts using the simple
        % voltage threshold algorithm with the parameters in the Excel file
        % (AR_Parameters_for_SVT_CRAP.xlsx) for this subject
        DimensionsOfFile2 = size(alldata2);
        for j = 1:DimensionsOfFile2(1)
            if isequal(SUB{i},num2str(alldata2{j,1}));
                if isequal(alldata2{j,2}, 'default')
                    Channels = 1:63; %This operation is performed on all channels except for the bipolar HEOG and VEOG channels - change this here
                else
                    Channels = str2num(alldata2{j,2});
                end
                ThresholdMinimum = alldata2{j,3};
                ThresholdMaximum = alldata2{j,4};
                TimeWindowMinimum = alldata2{j,5};
                TimeWindowMaximum = alldata2{j,6};
            end
        end
    
        EEG  = pop_artextval( EEG , 'Channel',  Channels, 'Flag', [1 2], 'Threshold', [ThresholdMinimum ThresholdMaximum], 'Twindow', [TimeWindowMinimum  TimeWindowMaximum] ); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1, 'setname', [SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins_epoch_arSVT'], 'gui', 'on'); 
    
        % Identify segments of EEG with C.R.A.P. artifacts using the moving
        % window peak-to-peak algorithm with the parameters in the Excel file
        % (AR_Parameters_for_MW_CRAP.xlsx) for this subject
        DimensionsOfFile3 = size(alldata3);
        for j = 1:DimensionsOfFile3(1)
            if isequal(SUB{i},num2str(alldata3{j,1}));
                if isequal(alldata3{j,2}, 'default')
                    Channels = 1:62; %This operation is performed on all the non-occular channels - change this here
                else
                    Channels = str2num(alldata3{j,2});
                end
                Threshold = alldata3{j,3};
                TimeWindowMinimum = alldata3{j,4};
                TimeWindowMaximum = alldata3{j,5};
                WindowSize = alldata3{j,6};
                WindowStep = alldata3{j,7};
            end
        end
    
        EEG  = pop_artmwppth( EEG , 'Channel',  Channels, 'Flag', [1 3], 'Threshold', Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize', WindowSize, 'Windowstep', WindowStep ); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2, 'setname', [SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins_epoch_arSVT_arMWcrap'], 'gui', 'on'); 
    
        % Identify segments of EEG with blink artifacts during the stimulus
        % presentation window (using the original non-ICA corrected VEOG
        % signal) with the moving window peak-to-peak algorithm with the
        % parameters in the Excel file (AR_Parameters_for_MW_Blinks.xlsx) for
        % this subject
        DimensionsOfFile4 = size(alldata4);
        for j = 1:DimensionsOfFile4(1)
            if isequal(SUB{i},num2str(alldata4{j,1}));
                Channel = alldata4{j,2}; %This operation is performed on the non-ICA corrected bipolar VEOG channel - change this in the Excel file
                Threshold = alldata4{j,3};
                TimeWindowMinimum = alldata4{j,4};
                TimeWindowMaximum = alldata4{j,5};
                WindowSize = alldata4{j,6};
                WindowStep = alldata4{j,7};
            end
        end
    
        EEG  = pop_artmwppth( EEG , 'Channel',  Channel, 'Flag', [1 4], 'Threshold', Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize', WindowSize, 'Windowstep', WindowStep ); 
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3, 'setname', [SUB{i} '-' portion{p} '_ICAR_interp_reref_elist_bins_epoch_arSVT_arMWcrap_arMWeyes'], 'savenew', [Subject_Path SUB{i} '-' portion{p} '_allAR.set'], 'gui', 'on');
    
        % % Identify segments of EEG with horizontal eye movement artifacts
        % % during the stimulus presentation window (using the original non-ICA
        % % corrected HEOG signal) with the step like algorithm with the
        % % parameters in the Excel file
        % % (AR_Parameters_for_SL_HEOG_Stim_Pres.xlsx) for this subject
        % DimensionsOfFile5 = size(alldata5);
        % for j = 1:DimensionsOfFile5(1)
        %     if isequal(SUB{i},num2str(alldata5{j,1}));
        %         Channel = alldata5{j,2}; %This operation is performed on the non-ICA corrected bipolar HEOG channel - change this in the Excel file (not using bipolar channels right now)
        %         Threshold = alldata5{j,3};
        %         TimeWindowMinimum = alldata5{j,4};
        %         TimeWindowMaximum = alldata5{j,5};
        %         WindowSize = alldata5{j,6};
        %         WindowStep = alldata5{j,7};
        %     end
        % end
        % 
        % EEG  = pop_artstep( EEG , 'Channel', Channel, 'Flag', [1 5], 'Threshold',  Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize',  WindowSize, 'Windowstep', WindowStep );
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4, 'setname', [SUB{i} '_arSVT_arMWcrap_arMWeyes_arSL1'], 'gui', 'on'); 
    
        % % Identify segments of EEG with any uncorrected horizontal eye movement
        % % artifacts (using the ICA-corrected HEOG signal) with the step like
        % % algorithm with the parameters in the Excel file
        % % (AR_Parameters_for_SL_HEOG.xlsx) for this subject
        % DimensionsOfFile6 = size(alldata6);
        % for j = 1:DimensionsOfFile6(1)
        %     if isequal(SUB{i},num2str(alldata6{j,1}));
        %         Channel = alldata6{j,2}; %This operation is performed on the ICA-corrected HEOG channel - change this in the Excel file 
        %         Threshold = alldata6{j,3};
        %         TimeWindowMinimum = alldata6{j,4};
        %         TimeWindowMaximum = alldata6{j,5};
        %         WindowSize = alldata6{j,6};
        %         WindowStep = alldata6{j,7};
        %     end
        % end
        % 
        % EEG  = pop_artstep( EEG , 'Channel', Channel, 'Flag', [1 6], 'Threshold',  Threshold, 'Twindow', [TimeWindowMinimum  TimeWindowMaximum], 'Windowsize',  WindowSize, 'Windowstep', WindowStep );
        % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 5, 'setname', [SUB{i} '_arSVT_arMWcrap_arMWeyes_arSL1_arSL2'], 'savenew', [Subject_Path SUB{i} '_allAR.set'], 'gui', 'on'); 

    % End portion loop
    end
% End subject loop
end

%*************************************************************************************************************************************
