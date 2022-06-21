loopProgram = true;

while (loopProgram)

    listOfFiles = openFolder();
    mergedDataset = mergeDatasetFromFileList(listOfFiles);
    
    % adding id_row to the Additional_Spectrum_Information table
    mergedDataset.Additional_Spectrum_Information.ID_Row = ...
        linspace(1, height(mergedDataset.Additional_Spectrum_Information), height(mergedDataset.Additional_Spectrum_Information))';
    mergedDataset.Additional_Spectrum_Information = movevars(mergedDataset.Additional_Spectrum_Information, "ID_Row","Before","Volume");

    % adding id_row to the Spectrum.Y table
    mergedDataset.Spectrum.Y.ID_Row = ...
        linspace(1, height(mergedDataset.Additional_Spectrum_Information), height(mergedDataset.Additional_Spectrum_Information))';
    mergedDataset.Spectrum.Y = movevars(mergedDataset.Spectrum.Y, "ID_Row", "Before", "y1");
    
    notSaved = true;
    while(notSaved)

        [filename, filepath] = uiputfile({'*.mat', 'MAT-files (*.mat)'}, ...
            'Save Merged dataset', '../../0-Dataset/1-Merged/merged_dataset.mat');
        if ischar(filename)
            save(fullfile(filepath, filename), '-struct', 'mergedDataset');
            notSaved = false;
        end
    end
   
    fprintf("\n-----------------------------------------------\n");
    str = input('Add new files? [Y]/[N]: ','s');
    if not(isempty(str))
        if strcmpi(str,"n")
            loopProgram = false;
        end
    end    
    fprintf("\n-----------------------------------------------\n");
end


%% Merge dataset from filelist
function [mergedDataset] = mergeDatasetFromFileList(listOfFile)
    numFile = height(listOfFile);
    listOfFile = struct2table(listOfFile);
    tableResult = table();
    
    for i = 1: numFile
        folderName = string(strcat(listOfFile.folder(i),'\',listOfFile.name(i)));
        nextTable = importFile(folderName);     
        tableResult = [tableResult; nextTable]; 	 	 	 	      
    end
    cellParameters = array2table(str2double(split(tableResult.Cell_Parameters, ' ')), ...
        'VariableNames', {'a','b','c', 'alpha', 'beta', 'gamma'});
   
    tableResult.Cell_Parameters = [];
    tableResult = [tableResult cellParameters];
    spectrum = splitSpectrum(tableResult.Spectrum);

    tableResult.Spectrum = [];

    mergedDataset = struct ('Spectrum', spectrum,...
        'Additional_Spectrum_Information', tableResult);
end

%% Split spectrum in atoms
function [spectrum] = splitSpectrum(rawSpectrum)
    coordinateSpectrum = split(rawSpectrum, ' ');
    coordinateSpectrum = str2double(split(coordinateSpectrum, ';'));

    nCoord = width(coordinateSpectrum(:,:,1));
    xName = cell(1,nCoord);
    yName = cell(1,nCoord);

    for i = 1:nCoord
        xName(i) = {strcat('x', num2str(i))};
        yName(i) = {strcat('y', num2str(i))};
    end

    x = array2table(coordinateSpectrum(:,:,1), 'VariableNames',xName);
    x = x(1,:);
    y = array2table(coordinateSpectrum(:,:,2), 'VariableNames',yName);

    spectrum = struct();
    spectrum.X = x;
    spectrum.Y = y;
end



%% Select a folder in which data are stored
function [files] = openFolder ()
    d = uigetdir('../../0-Dataset/0-Original', 'Select a folder with dataset');
    files = dir(fullfile(d, '*.txt'));   
end

%% Read file from path
function [NewFileImported] = importFile(PathNameFile)    
      NewFileImported = readtable(PathNameFile,'Delimiter',{'|'});
   NewFileImported.Properties.VariableNames = {'Spectrum', 'Cell_Parameters', ...
       'Volume', 'ID_Spectrum', 'Type', 'ID_Type_1', 'ID_Type_2', 'ID_Type_3', ...
       'ID_Type_4', 'ID_Type_5', 'ID_Type_6', 'ID_Type_7' };
end



