function [dataset] = create_dataset(xSpectrum, ySpectrum, additionalInformationSpectrum, response, ...
    nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero )
    %CREATE_DATASET Function to create the dataset to be used in the experiment, according to the user request
    %   params: m
    
    ySpectrum.ID_Row = [];
    
    %% Create table to store the data which we will use in the experiments
    featureNames = cell(1,nPeaksToKeep);
    for i = 1:nPeaksToKeep
        featureNames(i) = {strcat('x', num2str(i))};
    end
    featureNames = [{'Id'} featureNames response];
    
    nObservations = height(ySpectrum);
    dataset = table('Size', [0, nPeaksToKeep+width(response)+1], ...
        'VariableTypes', string(repmat('double',nPeaksToKeep+width(response)+1,1))',...
        'VariableNames', featureNames);
    
    totalNPeaks = zeros(nObservations,1);
    xMaxPeaks = zeros(nObservations,1);
    
    %% Find peaks for each observations
    for i = 1:nObservations
        
        observation = table2array(ySpectrum(i,:));
        [pks,locs] = findpeaks(observation);
    
        locsGreaterThreshold = locs(pks > threshold);
        xPeaksFeatures = xSpectrum(:,locsGreaterThreshold);
    
        % NUMERO TOTALE DI PICCHI A PRESCINDERE DALLA SOGLIA OPPURE NEL TOTALE PICCHI PRENDO SOLO QUELLI CHE SUPERANO LA SOGLIA???
        %  STO PRENDENDO IL NUMERO TOTALE DI PICCHI CHE SUPERA LA SOGLIA,
        %  NON IL NUMERO TOTALE DI PICCHI A PRESCINDERE DALLA SOGLIA
        totalNPeaks(i) = width(locsGreaterThreshold);
        %%
    
        [~, xMaxCoord] = max(table2array(ySpectrum(i,:)));
        xMaxPeaks(i) = table2array(xSpectrum(1, xMaxCoord));
    
        % If there are a number of peaks Greater than the threshold which
        % are grather than nPeaksToKeep, then we keep only the first
        % nPeaksToKeep. So we save this row in the dataset.
        if(width(xPeaksFeatures) >= nPeaksToKeep)
            xPeaksFeatures = xPeaksFeatures(:,1: nPeaksToKeep);
            dataset(i,:) = [array2table(i) xPeaksFeatures additionalInformationSpectrum(i,response)];
        else
            % In this case, the number of peaks is less than nPeaksToKeep, so in
            % this case we have two choices: removing the row or replace the
            % missing peaks with zero in the corresponding feature. User can
            % select one on this modality.
            if (replaceMissingPeaksWithZero)
                % In this case we replace with zeroes the missing peaks
                missingPeaks = zeros(1, nPeaksToKeep-totalNPeaks(i));
                dataset(i,:) = [array2table(i) xPeaksFeatures array2table(missingPeaks) additionalInformationSpectrum(i,response)];
            end
        end
    end

    if(useMaxPeaks)
        dataset.MaxPeaks = xMaxPeaks;
    end

    if(useTotalNPeaks)
        dataset.TotalPeaks = totalNPeaks;
    end
    
    if(~replaceMissingPeaksWithZero)
        dataset(sum(table2array(dataset(:,2:nPeaksToKeep+1)),2) == 0,:) = [];
    end
end