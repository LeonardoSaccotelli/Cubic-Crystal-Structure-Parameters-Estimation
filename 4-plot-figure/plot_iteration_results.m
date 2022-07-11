%{
addpath(genpath('..\3-trained-models'));

cubic10 = load("..\3-trained-models\cubic_10peaks_1threshold_MaxPeaks_NTotalPeaks_Used_NoReplaceWithZero.mat");
cubic15 = load("..\3-trained-models\cubic_15.mat");
cubic20 = load("..\3-trained-models\cubic_20.mat");
cubic25 = load("..\3-trained-models\cubic_25.mat");
cubic30 = load("..\3-trained-models\cubic_30.mat");
cubic40 = load("..\3-trained-models\cubic_40.mat");
cubic50 = load("..\3-trained-models\cubic_50.mat");

nPeaksToKeep = [10 15 20 25 30 40 50];

%Create table for k-fold cross validation results
algorithm_names = {'random_forest', 'lsboost', 'neural_network', 'regression_tree'};

results_test = table('Size', [numel(nPeaksToKeep) 4], ...
    'VariableTypes', {'double','double','double', 'double'}, ...
    'VariableNames', algorithm_names,...
    'RowNames', string(nPeaksToKeep));
%}

results_test("10","random_forest") = {cubic10.result_trained_model.random_forest.test_results.test_metrics.RMSE};
results_test("15","random_forest") = {cubic15.result_trained_model.random_forest.test_results.test_metrics.RMSE};
results_test("20","random_forest") = {cubic20.result_trained_model.random_forest.test_results.test_metrics.RMSE};
results_test("25","random_forest") = {cubic25.result_trained_model.random_forest.test_results.test_metrics.RMSE};
results_test("30","random_forest") = {cubic30.result_trained_model.random_forest.test_results.test_metrics.RMSE};
results_test("40","random_forest") = {cubic40.result_trained_model.random_forest.test_results.test_metrics.RMSE};
results_test("50","random_forest") = {cubic50.result_trained_model.random_forest.test_results.test_metrics.RMSE};

results_test("10","lsboost") = {cubic10.result_trained_model.lsboost.test_results.test_metrics.RMSE};
results_test("15","lsboost") = {cubic15.result_trained_model.lsboost.test_results.test_metrics.RMSE};
results_test("20","lsboost") = {cubic20.result_trained_model.lsboost.test_results.test_metrics.RMSE};
results_test("25","lsboost") = {cubic25.result_trained_model.lsboost.test_results.test_metrics.RMSE};
results_test("30","lsboost") = {cubic30.result_trained_model.lsboost.test_results.test_metrics.RMSE};
results_test("40","lsboost") = {cubic40.result_trained_model.lsboost.test_results.test_metrics.RMSE};
results_test("50","lsboost") = {cubic50.result_trained_model.lsboost.test_results.test_metrics.RMSE};

results_test("10","neural_network") = {cubic10.result_trained_model.neural_network.test_results.test_metrics.RMSE};
results_test("15","neural_network") = {cubic15.result_trained_model.neural_network.test_results.test_metrics.RMSE};
results_test("20","neural_network") = {cubic20.result_trained_model.neural_network.test_results.test_metrics.RMSE};
results_test("25","neural_network") = {cubic25.result_trained_model.neural_network.test_results.test_metrics.RMSE};
results_test("30","neural_network") = {cubic30.result_trained_model.neural_network.test_results.test_metrics.RMSE};
results_test("40","neural_network") = {cubic40.result_trained_model.neural_network.test_results.test_metrics.RMSE};
results_test("50","neural_network") = {cubic50.result_trained_model.neural_network.test_results.test_metrics.RMSE};

results_test("10","regression_tree") = {cubic10.result_trained_model.regression_tree.test_results.test_metrics.RMSE};
results_test("15","regression_tree") = {cubic15.result_trained_model.regression_tree.test_results.test_metrics.RMSE};
results_test("20","regression_tree") = {cubic20.result_trained_model.regression_tree.test_results.test_metrics.RMSE};
results_test("25","regression_tree") = {cubic25.result_trained_model.regression_tree.test_results.test_metrics.RMSE};
results_test("30","regression_tree") = {cubic30.result_trained_model.regression_tree.test_results.test_metrics.RMSE};
results_test("40","regression_tree") = {cubic40.result_trained_model.regression_tree.test_results.test_metrics.RMSE};
results_test("50","regression_tree") = {cubic50.result_trained_model.regression_tree.test_results.test_metrics.RMSE};

plotIterationResults(results_test, algorithm_names, nPeaksToKeep);
writetable(results_test, 'results_iteration.xlsx', 'WriteRowNames',true);

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
