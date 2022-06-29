function [nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero, response] = insert_dataset_structure_details()
%INSERT_DATASET_STRUCTURE_DETAILS Form to insert dataset structure details by user
    fprintf('Insert dataset structure details\n');

    while 1
        fprintf("---------------------------------------------------------------------------------");
        nPeaksToKeep = input('\n1) Insert the number of peaks to use as features in the experiment: ');
        if(isnumeric(nPeaksToKeep))
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        threshold = input('\n2) Insert the threshold used to select the peaks in the experiment: ');
        if(isnumeric(threshold))
            break;
        end
    end


    while 1
        fprintf("---------------------------------------------------------------------------------");
        useMaxPeaks = input('\n3) Do you want to use maxPeaks as a feature in the experiment? [Y|N]: ', 's');
        if isequal(lower(useMaxPeaks), 'y')
            useMaxPeaks = true;
            break;
        elseif isequal(lower(useMaxPeaks), 'n')
            useMaxPeaks = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        useTotalNPeaks = input('\n4) Do you want to use totalNPeaks as a feature in the experiment? [Y|N]: ', 's');
        if isequal(lower(useTotalNPeaks), 'y')
            useTotalNPeaks = true;
            break;
        elseif isequal(lower(useTotalNPeaks), 'n')
            useTotalNPeaks = false;
            break;
        end
    end
   
    while 1
        fprintf("---------------------------------------------------------------------------------");
        replaceMissingPeaksWithZero = input('\n5) Do you want to replace missing peaks with zero in the experiment? [Y|N]: ', 's');
        if isequal(lower(replaceMissingPeaksWithZero), 'y')
            replaceMissingPeaksWithZero = true;
            break;
        elseif isequal(lower(replaceMissingPeaksWithZero), 'n')
            replaceMissingPeaksWithZero = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        aIsResponse = input('\n6) "a" is a response feature ? [Y|N]: ', 's');
        if isequal(lower(aIsResponse), 'y')
            aIsResponse = true;
            break;
        elseif isequal(lower(aIsResponse), 'n')
            aIsResponse = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        bIsResponse = input('\n7) "b" is a response feature ? [Y|N]: ', 's');
        if isequal(lower(bIsResponse), 'y')
            bIsResponse = true;
            break;
        elseif isequal(lower(bIsResponse), 'n')
            bIsResponse = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        cIsResponse = input('\n8) "c" is a response feature ? [Y|N]: ', 's');
        if isequal(lower(cIsResponse), 'y')
            cIsResponse = true;
            break;
        elseif isequal(lower(cIsResponse), 'n')
            cIsResponse = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        alphaIsResponse = input('\n9) "alpha" is a response feature ? [Y|N]: ', 's');
        if isequal(lower(alphaIsResponse), 'y')
            alphaIsResponse = true;
            break;
        elseif isequal(lower(alphaIsResponse), 'n')
            alphaIsResponse = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        betaIsResponse = input('\n10) "beta" is a response feature ? [Y|N]: ', 's');
        if isequal(lower(betaIsResponse), 'y')
            betaIsResponse = true;
            break;
        elseif isequal(lower(betaIsResponse), 'n')
            betaIsResponse = false;
            break;
        end
    end

    while 1
        fprintf("---------------------------------------------------------------------------------");
        gammaIsResponse = input('\n11) "gamma" is a response feature ? [Y|N]: ', 's');
        if isequal(lower(gammaIsResponse), 'y')
            gammaIsResponse = true;
            break;
        elseif isequal(lower(gammaIsResponse), 'n')
            gammaIsResponse = false;
            break;
        end
    end
    fprintf("---------------------------------------------------------------------------------");


    response = {};

    if (aIsResponse)
        response(1) = {'a'};
    end
    
    if (bIsResponse)
        response(2) = {'b'};
    end

    if (cIsResponse)
        response(3) = {'c'};
    end

    if (alphaIsResponse)
        response(4) = {'alpha'};
    end

    if (betaIsResponse)
        response(5) = {'beta'};
    end
    
    if (gammaIsResponse)
        response(6) = {'gamma'};
    end

    response(cellfun('isempty',response)) = [];
end 