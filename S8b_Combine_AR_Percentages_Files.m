% Define the main directory where subject folders are located
mainDir = '/Volumes/Life Support/PADLD/PADLD EEG Data';

% Get a list of all subject folders
subjectFolders = dir(mainDir);
subjectFolders = subjectFolders([subjectFolders.isdir] & ~ismember({subjectFolders.name}, {'.', '..'}));

% Initialize table to store combined data
combinedData = table();

% Loop through each subject's folder
for i = 1:length(subjectFolders)
    subjectDir = fullfile(mainDir, subjectFolders(i).name);
    
    % Get list of CSV files in the subject's folder
    csvFiles = dir(fullfile(subjectDir, '*.csv'));
    
    % Loop through each CSV file
    for j = 1:length(csvFiles)
        % Read the CSV file
        csvFilePath = fullfile(subjectDir, csvFiles(j).name);
        data = readtable(csvFilePath);
        
        % Determine if the file is a word or picture file
        if contains(csvFiles(j).name, 'word')
            fileType = 'Word';
        elseif contains(csvFiles(j).name, 'picture')
            fileType = 'Picture';
        else
            continue; % Skip if neither word nor picture
        end
        
        % Add a column with the subject ID and file type
        subjectID = subjectFolders(i).name;
        data.SubjectID = repmat({subjectID}, height(data), 1);
        data.FileType = repmat({fileType}, height(data), 1);
        
        % Append to combined data table
        combinedData = [combinedData; data];
    end
end

% Write combined data to an Excel file
outputFilePath = fullfile(mainDir, 'combined_AR_percentages_data.xlsx');
writetable(combinedData, outputFilePath);

disp(['Combined data written to: ', outputFilePath]);