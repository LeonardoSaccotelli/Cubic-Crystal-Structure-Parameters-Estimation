%%PLOT_RESULTS Script to plot training and test results of a single experiment 
addpath(genpath('..\3-trained-models'));
addpath(genpath('..\7-utils'));

%% Load trained model with results
[data, filename] = open_folder();

% Check if dataset has been loaded correctly
fprintf("\n---------------------------------------------------------------------------------");
if isequal(data,0)
    fprintf('\nUser selected Cancel. Model has not be loaded!\n');
    fprintf("---------------------------------------------------------------------------------\n");
else
    fprintf(['\nUser selected the following model: ', filename, '\n']);
    fprintf("---------------------------------------------------------------------------------\n");

    result_trained_model = data.result_trained_model;
    algorithm_names = {'random forest', 'lsboost', 'neural network', 'regression tree'};
    pwbX = [1 5 10 20];
    pwbXRowNames = string();

    for i = 1:numel(pwbX)
        pwbXRowNames(i) = strcat('PWB', num2str(pwbX(i)));
    end
    
    real_obs = result_trained_model.dataset.test.a;
    pred_rf = result_trained_model.random_forest.test_results.test_predictions;
    pred_ls = result_trained_model.lsboost.test_results.test_predictions;
    pred_nn = result_trained_model.neural_network.test_results.test_predictions;
    pred_tree = result_trained_model.regression_tree.test_results.test_predictions;

    pwbTable = table('Size', [4 4], ...
        'VariableTypes', {'double','double','double','double'}, ...
        'VariableNames', algorithm_names,...
        'RowNames', pwbXRowNames);

    for i=1:numel(pwbX)
        pwbTable(i,"random forest") = {round(computePWBTable(real_obs, pred_rf, pwbX(i)),2)};
        pwbTable(i,"lsboost") = {round(computePWBTable(real_obs, pred_ls, pwbX(i)),2)};
        pwbTable(i,"neural network") = {round(computePWBTable(real_obs, pred_nn, pwbX(i)),2)};
        pwbTable(i,"regression tree") = {round(computePWBTable(real_obs, pred_tree, pwbX(i)),2)};
    end

    writetable(pwbTable, "pwbTable.xlsx", "WriteRowNames", true);
end

function [pwbTest] = computePWBTable (obs, pred, threshold)
    minBound = obs - (obs*threshold/100);
    maxBound = obs + (obs*threshold/100);
    countInBound = sum(pred>= minBound & pred<=maxBound);
    pwbTest = countInBound*100/numel(obs);
end