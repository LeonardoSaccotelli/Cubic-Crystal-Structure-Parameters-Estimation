%addpath(genpath('..\0-Dataset\1-Merged\'));
addpath(genpath('1-pre-processing'));
addpath(genpath('2-machine-learning-function'));
addpath(genpath('3-trained-models'));

%% Load dataset
[data, filename] = openFolder();

% Check if dataset has been loaded correctly
fprintf("\n---------------------------------------------------------------------------------");
if isequal(data,0)
    fprintf('\nUser selected Cancel. Dataset has not be loaded!\n');
    fprintf("---------------------------------------------------------------------------------\n");
else
    fprintf(['\nUser selected the following dataset: ', filename, '\n']);
    fprintf("---------------------------------------------------------------------------------\n");
    
    % Select the features to be included in the dataset
    [nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero, response] = insert_dataset_structure_details();
  
    dataset_for_experiment = create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero); 
   
    while 1    
        fprintf("---------------------------------------------------------------------------------");
        saveDataset = input('\n1) Do you want to save this dataset? [Y|N]: ', 's');
        if isequal(lower(saveDataset), 'y')
            notSaved = true;
            while(notSaved)
                [filename_saved, filepath] = uiputfile({'*.mat', 'MAT-files (*.mat)'}, ...
                    'Save dataset', strcat('../0-Dataset/2-Pre-Processed/', '_processed'));
                if ischar(filename_saved)
                    save(fullfile(filepath, filename_saved), 'dataset_for_experiment');
                    filename_saved = split(filename_saved,'.');
                    writetable(dataset_for_experiment, strcat('../0-Dataset/2-Pre-Processed/',string(filename_saved(1)), '.xlsx'));
                    notSaved = false;
                end
            end
        end

        break;
    end

    % We can start the experiment

    
    
    
    
    
    
    
    result_trained_model = struct();

    result_trained_model.dataset_details = string(sprintf(['Dataset details:', ...
    '\n[0 = false, 1 = true]', ...
    '\n1) Total number of peaks used: %d\n', ...
    '\n2) Peaks threshold: %d\n', ...
    '\n3) MaxPeaks has been used: %d\n', ...
    '\n4) TotalNPeaks has been used: %d\n', ...
    '\n5) MissingPeaks replaced with zero: %d'],[nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero]));




end








%% Select a file in which data are stored
function [dataStruct, filename] = openFolder ()
    dataStruct = 0;
    [filename,pathfile] = uigetfile('../0-Dataset/1-Merged/', 'Select a dataset');
    if(filename ~= 0)
        dataStruct = load(fullfile(pathfile,filename));
    end
end

