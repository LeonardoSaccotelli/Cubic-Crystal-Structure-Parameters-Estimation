%RUN_EXPERIMENT Script to run the experiment

%addpath(genpath('..\0-Dataset\1-Merged\'));
addpath(genpath('1-pre-processing'));
addpath(genpath('2-machine-learning-function'));
addpath(genpath('3-trained-models'));
addpath(genpath('7-utils'));

%% Load dataset
[data, filename] = open_folder();

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

    %% Running the experiment

    %Create table for k-fold cross validation results
    algorithm_names = {'random_forest', 'lsboost', 'neural_network', 'regression_tree'};
    
    results_training = table('Size', [4 7], ...
        'VariableTypes', {'double','double','double', 'double', 'double', 'double', 'double'}, ...
        'VariableNames', {'RMSE', 'MAE','RSE', 'RRSE','RAE', 'R2', 'Corr Coeff'},...
        'RowNames', algorithm_names);
    
    results_test = table('Size', [4 7], ...
        'VariableTypes', {'double','double','double', 'double', 'double', 'double', 'double'}, ...
        'VariableNames', {'RMSE', 'MAE','RSE', 'RRSE','RAE', 'R2', 'Corr Coeff'},...
        'RowNames', algorithm_names);

    result_trained_model = struct();
    
    % Set maxObjectiveEvaluations as maximum number of objective functions to
    %  be evaluated in the optimization process
    max_objective_evaluations = 30;
    
    % Set k for k-fold cross validarion
    k = 10;

    % Split dataset in training and test set
    [training_dataset, test_dataset] = create_training_test_dataset(dataset_for_experiment,0.3);

    %% Training random forest model
    fprintf("\n===================================================================\n");
    fprintf(strcat("Training model using ", algorithm_names(1), " with k=", string(k), "\n"));
    fprintf("===================================================================\n");
    
    % save training results and performance
    result_trained_model.random_forest = random_forest_function(training_dataset(:,2:end),response,max_objective_evaluations, k);
    results_training = compute_metrics(training_dataset(:,response), result_trained_model.random_forest.validation_results.validation_predictions, algorithm_names(1), results_training);
    
    result_trained_model.random_forest.test_results.test_predictions = result_trained_model.random_forest.model.predictFcn(test_dataset);
    results_test = compute_metrics(test_dataset(:,response), result_trained_model.random_forest.test_results.test_predictions, algorithm_names(1), results_test);
    
    result_trained_model.random_forest.validation_results.validation_metrics = results_training(algorithm_names(1), :);
    result_trained_model.random_forest.test_results.test_metrics = results_test(algorithm_names(1),:);
    
    %% Training Lsboost model
    fprintf("\n===================================================================\n");
    fprintf(strcat("Training model using ", algorithm_names(2), " with k=", string(k), "\n"));
    fprintf("===================================================================\n");
    
    % save training results and performance
    result_trained_model.lsboost = lsboost_function(training_dataset(:,2:end),response,max_objective_evaluations, k);
    results_training = compute_metrics(training_dataset(:,response), result_trained_model.lsboost.validation_results.validation_predictions, algorithm_names(2), results_training);
    
    result_trained_model.lsboost.test_results.test_predictions = result_trained_model.lsboost.model.predictFcn(test_dataset);
    results_test = compute_metrics(test_dataset(:,response), result_trained_model.lsboost.test_results.test_predictions, algorithm_names(2), results_test);
    
    result_trained_model.lsboost.validation_results.validation_metrics = results_training(algorithm_names(2), :);
    result_trained_model.lsboost.test_results.test_metrics = results_test(algorithm_names(2),:);

%}
    %% Training Neural network model
    fprintf("\n===================================================================\n");
    fprintf(strcat("Training model using ", algorithm_names(3), " with k=", string(k), "\n"));
    fprintf("===================================================================\n");
    
    % save training results and performance
    result_trained_model.neural_network = neural_network_function(training_dataset(:,2:end),response,1,3,1,50,max_objective_evaluations, k);
    results_training = compute_metrics(training_dataset(:,response), result_trained_model.neural_network.validation_results.validation_predictions, algorithm_names(3), results_training);
    
    result_trained_model.neural_network.test_results.test_predictions = result_trained_model.neural_network.model.predictFcn(test_dataset);
    results_test = compute_metrics(test_dataset(:,response), result_trained_model.neural_network.test_results.test_predictions, algorithm_names(3), results_test);
    
    result_trained_model.neural_network.validation_results.validation_metrics = results_training(algorithm_names(3), :);
    result_trained_model.neural_network.test_results.test_metrics = results_test(algorithm_names(3),:);


    %% Training Regression tree
    fprintf("\n===================================================================\n");
    fprintf(strcat("Training model using ", algorithm_names(4), " with k=", string(k), "\n"));
    fprintf("===================================================================\n");
    
    % save training results and performance
    result_trained_model.regression_tree = regression_tree_function(training_dataset(:,2:end),response,max_objective_evaluations, k);
    results_training = compute_metrics(training_dataset(:,response), result_trained_model.regression_tree.validation_results.validation_predictions, algorithm_names(4), results_training);
    
    result_trained_model.regression_tree.test_results.test_predictions = result_trained_model.regression_tree.model.predictFcn(test_dataset);
    results_test = compute_metrics(test_dataset(:,response), result_trained_model.regression_tree.test_results.test_predictions, algorithm_names(4), results_test);
    
    result_trained_model.regression_tree.validation_results.validation_metrics = results_training(algorithm_names(4), :);
    result_trained_model.regression_tree.test_results.test_metrics = results_test(algorithm_names(4),:);
    close all;
   
    %% Add information about dataset details
    result_trained_model.dataset_details = string(sprintf(['Dataset details:', ...
    '\n[0 = false, 1 = true]', ...
    '\n1) Total number of peaks used: %d\n', ...
    '\n2) Peaks threshold: %d\n', ...
    '\n3) MaxPeaks has been used: %d\n', ...
    '\n4) TotalNPeaks has been used: %d\n', ...
    '\n5) MissingPeaks replaced with zero: %d'],[nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero]));

    result_trained_model.dataset.training = training_dataset;
    result_trained_model.dataset.test = test_dataset;
    result_trained_model.summary_metrics.validation_metrics = results_training;
    result_trained_model.summary_metrics.test_metrics = results_test;


    %% Save results
    while 1    
        fprintf("---------------------------------------------------------------------------------");
        saveDataset = input('\n1) Do you want to save these trained models? [Y|N]: ', 's');
        if isequal(lower(saveDataset), 'y')
            notSaved = true;
            while(notSaved)
                [filename_saved, filepath] = uiputfile({'*.mat', 'MAT-files (*.mat)'}, ...
                    'Save trained model', strcat('3-trained-models/', ''));
                if ischar(filename_saved)
                    save(fullfile(filepath, filename_saved), 'result_trained_model');
                    notSaved = false;
                end
            end
        end

        break;
    end
end