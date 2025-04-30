
% List of subjects to process, based on the name of the folder that
% contains that subject's data
SUB = {'010224-BS-PADLD' ,'011824-VA-PADLD','013024-LK-PADLD','013024-PR-PADLD','013024-TR-PADLD','030624-CG-PADLD','030624-LG-PADLD','030924-HCR-PADLD','030924-HGR-PADLD','031324-AH-PADLD','031324-ZH-PADLD','031924-LC-PADLD','032424-JV-PADLD','032824-JG-PADLD','032824-SG-PADLD','040124-CP-PADLD','040824-LH-PADLD','040924-EK-PADLD','042524-DH-PADLD','042524-NH-PADLD','050624-AF-PADLD','050724-AF-PADLD','050924-EL-PADLD','101923-DV-PADLD','102623-HJ-PADLD','110123-AN-PADLD','110123-BN-PADLD','110123-CB-PADLD','111023-JH-PADLD','111023-RH-PADLD','112423-AD-PADLD','120423-ND-PADLD','120623-RH-PADLD','122023-ZG-PADLD','122923-AS-PADLD','122923-JM-PADLD','122923-MS-PADLD','122923-TM-PADLD','032824-RG-PADLD','032924-JC-PADLD','041524-JH-PADLD'};

% Define the directory containing the .log files and the output file name
% and path
directoryPath = '/Volumes/Life Support/PADLD/PADLD Presentation Data'; % Specify your directory path
outputFileName = 'combined_data.xlsx';
outputFilePath = fullfile(directoryPath, outputFileName);

% Define the range to copy from each sheet
dataRange = 'A1:M1896';

% Specify the expected column names
expectedColumnNames = {'Subject', 'Trial', 'Event Type', 'Code', 'Time', 'TTime', ...
                       'Uncertainty', 'Duration', 'Uncertainty', 'ReqTime', 'ReqDur', ...
                       'Stim Type', 'Pair Index'};

% Get the list of files matching the pattern 'subject*.xlsx'
filePattern = fullfile(directoryPath, '*List*.log');
logFiles = dir(filePattern);

% Initialize an empty table to store combined data
combinedData = [];

% Loop through each .log file
for fileIdx = 1:length(logFiles)
    % Get the full file name of the current .log file
    currentFileName = fullfile(directoryPath, logFiles(fileIdx).name);
    
    % Read data from the .log file
    currentData = readtable(currentFileName, 'FileType', 'text', 'Delimiter', '\t', 'ReadVariableNames', true);
    
    % Convert relevant columns to consistent data types
    if ismember('Subject', currentData.Properties.VariableNames)
        if isnumeric(currentData.Subject)
            currentData.Subject = cellstr(num2str(currentData.Subject));
        elseif iscategorical(currentData.Subject)
            currentData.Subject = cellstr(currentData.Subject);
        end
    end
    
    if ismember('Code', currentData.Properties.VariableNames)
        if isnumeric(currentData.Code)
            currentData.Code = cellstr(num2str(currentData.Code));
        elseif iscategorical(currentData.Code)
            currentData.Code = cellstr(currentData.Code);
        end
    end
    
    if ismember('ReqDur', currentData.Properties.VariableNames)
        if iscell(currentData.ReqDur)
            % Attempt to convert cells to numeric
            try
                numericReqDur = cell2mat(cellfun(@str2double, currentData.ReqDur, 'UniformOutput', false));
                currentData.ReqDur = numericReqDur;
            catch
                % If conversion fails, convert to string
                currentData.ReqDur = cellfun(@num2str, currentData.ReqDur, 'UniformOutput', false);
            end
        elseif isnumeric(currentData.ReqDur)
            % Ensure ReqDur is numeric
            currentData.ReqDur = currentData.ReqDur;
        else
            % If not numeric or cell, convert to string
            currentData.ReqDur = num2str(currentData.ReqDur);
        end
    end
    
    % Ensure the table has the expected columns, filling missing columns with NaN or ''
    missingCols = setdiff(expectedColumnNames, currentData.Properties.VariableNames);
    for col = missingCols
        if ismember(col{1}, {'Subject', 'Code', 'Event Type', 'Stim Type'})
            currentData.(col{1}) = repmat({''}, height(currentData), 1);
        else
            currentData.(col{1}) = NaN(height(currentData), 1);
        end
    end
    
    % Reorder the columns to match the expected order
    currentData = currentData(:, expectedColumnNames);
    
    % Convert columns to the appropriate types
    % Make sure all tables have the same data types
    if isempty(combinedData)
        combinedData = currentData;
    else
        % Ensure consistent data types across all tables
        for col = expectedColumnNames
            if isnumeric(combinedData.(col{1}))
                if ~isnumeric(currentData.(col{1}))
                    currentData.(col{1}) = str2double(currentData.(col{1}));
                end
            elseif iscell(combinedData.(col{1}))
                if ~iscell(currentData.(col{1}))
                    currentData.(col{1}) = num2cell(currentData.(col{1}));
                end
            end
        end
        % Append the data to the combined table
        combinedData = [combinedData; currentData];
    end
end

% Write the combined data to a new Excel file
writetable(combinedData, outputFilePath);

disp(['Data has been successfully combined and written to ' outputFileName]);