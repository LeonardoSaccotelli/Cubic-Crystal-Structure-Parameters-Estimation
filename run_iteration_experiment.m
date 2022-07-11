%RUN_ITERATION_EXPERIMENT Script to run the experiment in iterative mode
%using different number of peaks for each experiment
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
    nPeaksToKeep = [10 15 20 25 30 40 50];
    threshold = 1;
    useMaxPeaks = true;
    useTotalNPeaks = true;
    replaceMissingPeaksWithZero = false;
    response = {'a'};

    %Create table for k-fold cross validation results
    algorithm_names = {'random_forest', 'lsboost', 'neural_network', 'regression_tree'};
    
    results_test = table('Size', [numel(nPeaksToKeep) 4], ...
        'VariableTypes', {'double','double','double', 'double'}, ...
        'VariableNames', algorithm_names,...
        'RowNames', string(nPeaksToKeep));

    result_trained_model = struct();
    
    % Set maxObjectiveEvaluations as maximum number of objective functions to
    %  be evaluated in the optimization process
    max_objective_evaluations = 30;
    
    % Set k for k-fold cross validarion
    k = 10;
  

    
    for i = 1: numel(nPeaksToKeep)
        dataset_for_experiment = create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
            nPeaksToKeep(i), threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero); 
        
        %% Running the experiment
        
        % Split dataset in training and test set
        [training_dataset, test_dataset] = create_training_test_dataset(dataset_for_experiment,0.3);

        %% Training random forest model
        fprintf("\n===================================================================\n");
        fprintf(strcat("Training model using ", algorithm_names(1), " with NPeaks=", string(nPeaksToKeep(i)), "\n"));
        fprintf("===================================================================\n");
        
        result_trained_model.random_forest = random_forest_function(training_dataset(:,2:end),response,max_objective_evaluations, k);
        results_test(i,"random_forest") = { computeRMSE(test_dataset.a, result_trained_model.random_forest.model.predictFcn(test_dataset))};
        
        %% Training Lsboost model
        fprintf("\n===================================================================\n");
        fprintf(strcat("Training model using ", algorithm_names(2), " with NPeaks=", string(nPeaksToKeep(i)), "\n"));
        fprintf("===================================================================\n");
        
        result_trained_model.lsboost = lsboost_function(training_dataset(:,2:end),response,max_objective_evaluations, k);
        results_test(i,"lsboost") = { computeRMSE(test_dataset.a, result_trained_model.lsboost.model.predictFcn(test_dataset))};
    
        %% Training Neural network model
        fprintf("\n===================================================================\n");
        fprintf(strcat("Training model using ", algorithm_names(3), " with NPeaks=", string(nPeaksToKeep(i)), "\n"));
        fprintf("===================================================================\n");
        
        result_trained_model.neural_network = neural_network_function(training_dataset(:,2:end),response,1,3,1,50,max_objective_evaluations, k);
        results_test(i,"neural_network") = { computeRMSE(test_dataset.a, result_trained_model.neural_network.model.predictFcn(test_dataset))};    
    
        %% Training Regression tree
        fprintf("\n===================================================================\n");
        fprintf(strcat("Training model using ", algorithm_names(4), " with NPeaks=", string(nPeaksToKeep(i)), "\n"));
        fprintf("===================================================================\n");
        
        % save training results and performance
        result_trained_model.regression_tree = regression_tree_function(training_dataset(:,2:end),response,max_objective_evaluations, k);
        results_test(i,"regression_tree") = { computeRMSE(test_dataset.a, result_trained_model.regression_tree.model.predictFcn(test_dataset))};    

        close all;
    end
    

    %% Add information about dataset details
    result_trained_model.dataset_details = string(sprintf(['Dataset details:', ...
    '\n[0 = false, 1 = true]', ...
    '\n1) Total number of peaks used: %d\n', ...
    '\n2) Peaks threshold: %d\n', ...
    '\n3) MaxPeaks has been used: %d\n', ...
    '\n4) TotalNPeaks has been used: %d\n', ...
    '\n5) MissingPeaks replaced with zero: %d'],[nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero]));

    result_trained_model.summary_iteration = results_test;

    plotIterationResults(results_test, algorithm_names, nPeaksToKeep);
    writetable(results_test, 'results_iteration.xlsx', 'WriteRowNames',true);
end

function [] = plotIterationResults(results, algorithm_names, nPeaksToKeep)
    if (istable(results))
        results = table2array(results);
    end

    plot(results, '--.','MarkerSize',18);
    %xlim([10 50]);
    %ylim([0 10]);
    xlabel('NPeak');
    ylabel('RMSE');
    xticklabels(num2cell(nPeaksToKeep));
    legend(strrep(algorithm_names,'_',' '),'Location','northwest');
    set(gca,'FontSize',12);
    grid on;
end


function [rmse] = computeRMSE(obs, pred)
    rmse = sqrt(sum((obs - pred).^2)/height(obs));
end


