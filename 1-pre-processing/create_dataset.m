loopProgram = true;

while (loopProgram)

    listOfFiles = openFolder();
    tableR = mergeDatasetFromFileList(listOfFiles);
    tableR.ID_Row = linspace(1, height(tableR), height(tableR))';
    tableR = movevars(tableR, "ID_Row","Before","Spectrum");
    notSaved = true;
    while(notSaved)
        str = input('Enter file name: ','s');
        if not(isempty(str))
             writetable(tableR,strcat(str,".xlsx"));
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
function [tableResult] = mergeDatasetFromFileList(listOfFile)
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
    splitSpectrum(tableResult.Spectrum);
end

%% Split spectrum in atoms
function [spectrum] = splitSpectrum(rawSpectrum)
    coordinateSpectrum = split(rawSpectrum, ' ');
    coordinateSpectrum = split(coordinateSpectrum, ';');
end



%% Select a folder in which data are stored
function [files] = openFolder ()
    d = uigetdir(pwd, 'Select a folder');
    files = dir(fullfile(d, '*.txt'));   
end

%% Read file from path
function [NewFileImported] = importFile(PathNameFile)    
      NewFileImported = readtable(PathNameFile,'Delimiter',{'|'});
   NewFileImported.Properties.VariableNames = {'Spectrum', 'Cell_Parameters', ...
       'Volume', 'ID_Spectrum', 'Type', 'ID_Type_1', 'ID_Type_2', 'ID_Type_3', ...
       'ID_Type_4', 'ID_Type_5', 'ID_Type_6', 'ID_Type_7' };
end



