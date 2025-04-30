% Taken from ERP CORE N400 Files; modified by Ashlie Pankonin August 2021
% and July 2024
% Operates on individual subject data
% This script loads the epoched and artifact rejected EEG data, creates an
% averaged ERP waveform, calculates the percentage of trials rejected for
% artifacts (in total and per bin) and saves the information to a .csv file
% in each subject's data folder, creates low-pass filtered versions of
% the ERP waveforms, and calculates ERP difference waveforms between
% conditions (if so desired).

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
% Averaged subjects: 

% List of portions to process
portion = {'picture','word'};

%**********************************************************************************************************************************************************************

% Create averaged ERP waveforms

% Open EEGLAB and ERPLAB Toolboxes  
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% %Loop through each subject listed in SUB
% for i = 1:length(SUB)
% 
%      for p = 1:length(portion)
% 
%         % Define subject path based on study directory and subject ID of current subject
%         Subject_Path = [DIR filesep SUB{i} filesep];
% 
%         % Load the epoched and artifact detected EEG data file outputted from S7 in .set EEGLAB file format
%         EEG = pop_loadset( 'filename', [SUB{i} '-' portion{p} '_allAR.set'], 'filepath', Subject_Path);
% 
%         % Create an averaged ERP waveform from the epochs that are *not*
%         % marked for rejection (i.e., as containing artifacts)
%         ERP = pop_averager( EEG , 'Criterion', 'good', 'ExcludeBoundary', 'on', 'SEM', 'on');
%         ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '-' portion{p} '_erp'], 'filename', [Subject_Path SUB{i} '-' portion{p} '_erp.erp']);
% 
%         % Apply a low-pass filter (non-causal Butterworth impulse response function, 20 Hz half-amplitude cut-off, 48 dB/oct roll-off) to the ERP waveforms
%         ERP = pop_filterp( ERP,  1:64 , 'Cutoff',  20, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  8 );
%         ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '-' portion{p} '_erp_20hzlpfilt'], 'filename', [Subject_Path SUB{i} '-' portion{p} '_erp_20hzlpfilt.erp']);
% 
%         % Calculate the percentage of trials that were rejected in each bin 
%         accepted = ERP.ntrials.accepted;
%         rejected= ERP.ntrials.rejected;
%         percent_rejected= rejected./(accepted + rejected)*100;
% 
%         % Calculate the total percentage of trials rejected across all trial types (first two bins)
%         total_accepted = accepted(1)+	accepted(2)+	accepted(3)+	accepted(4)+	accepted(5)+	accepted(6)+	accepted(7)+	accepted(8)+	accepted(9)+	accepted(10)+	accepted(11)+	accepted(12)+	accepted(13)+	accepted(14)+	accepted(15)+	accepted(16)+	accepted(17)+	accepted(18)+	accepted(19)+	accepted(20)+	accepted(21)+	accepted(22)+	accepted(23)+	accepted(24)+	accepted(25)+	accepted(26)+	accepted(27)+	accepted(28)+	accepted(29)+	accepted(30)+	accepted(31)+	accepted(32);
%         total_rejected= rejected(1)+	rejected(2)+	rejected(3)+	rejected(4)+	rejected(5)+	rejected(6)+	rejected(7)+	rejected(8)+	rejected(9)+	rejected(10)+	rejected(11)+	rejected(12)+	rejected(13)+	rejected(14)+	rejected(15)+	rejected(16)+	rejected(17)+	rejected(18)+	rejected(19)+	rejected(20)+	rejected(21)+	rejected(22)+	rejected(23)+	rejected(24)+	rejected(25)+	rejected(26)+	rejected(27)+	rejected(28)+	rejected(29)+	rejected(30)+	rejected(31)+	rejected(32);
%         total_percent_rejected= total_rejected./(total_accepted + total_rejected)*100; 
% 
%         % Save the percentage of trials rejected (in total and per bin) to a .csv file 
%         fid = fopen([DIR filesep SUB{i} filesep SUB{i} '-' portion{p} '_AR_Percentages.csv'], 'w');
%         fprintf(fid, 'SubID,Bin,Accepted,Rejected,Total Percent Rejected\n');
%         fprintf(fid, '%s,%s,%d,%d,%.2f\n', SUB{i}, 'Total', total_accepted, total_rejected, total_percent_rejected);
%         bins = strrep(ERP.bindescr,', ',' - ');
%         for b = 1:length(bins)
%             fprintf(fid, ',%s,%d,%d,%.2f\n', bins{b}, accepted(b), rejected(b), percent_rejected(b));
%         end
%         fclose(fid);
%     % End portion loop
%      end
% %End subject loop
% end 

%**********************************************************************************************************************************************************************

%Create difference waveforms 

%Loop through each subject listed in SUB
for i = 1:length(SUB)

    for p = 1:length(portion)

        %Define subject path based on study directory and subject ID of current subject
        Subject_Path = [DIR filesep SUB{i} filesep];

        %Load averaged ERP waveform (without the 20 Hz low-pass filter) 
        ERP = pop_loaderp('filename', [SUB{i} '-' portion{p} '_erp.erp'], 'filepath', Subject_Path);                                                                                                                                                                                                                                                                                                                                       

        %Create ERP difference waveforms between conditions
        ERP = pop_binoperator( ERP, [DIR filesep 'EEG Data Reference Files' filesep 'PADLD_Difference_Waves_Bins.txt']);
        ERP = pop_savemyerp(ERP, 'erpname', [SUB{i} '-' portion{p} '_erp_diffwaves'], 'filename', [Subject_Path SUB{i} '-' portion{p} '_erp_diffwaves.erp']);

        %Apply a low-pass filter (non-causal Butterworth impulse response function, 20 Hz half-amplitude cut-off, 48 dB/oct roll-off) to the difference waveforms
        ERP = pop_filterp( ERP,  1:64, 'Cutoff',  20, 'Design', 'butter', 'Filter', 'lowpass', 'Order',  8 );
        ERP = pop_savemyerp( ERP, 'erpname', [SUB{i} '-' portion{p} '_erp_diffwaves_20hzlpfilt'], 'filename', [Subject_Path SUB{i} '-' portion{p} '_erp_diffwaves_20hzlpfilt.erp']);

        % End portion loop
    end
%End subject loop
end
        
%**********************************************************************************************************************************************************************
