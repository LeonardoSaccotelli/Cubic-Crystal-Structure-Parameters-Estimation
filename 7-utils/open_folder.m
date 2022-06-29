function [dataStruct, filename] = open_folder ()
%OPEN_FOLDER Open a dialog box to select a file in which data are stored
    dataStruct = 0;
    [filename,pathfile] = uigetfile('../0-Dataset/1-Merged/', 'Select a dataset');
    if(filename ~= 0)
        dataStruct = load(fullfile(pathfile,filename));
    end
end