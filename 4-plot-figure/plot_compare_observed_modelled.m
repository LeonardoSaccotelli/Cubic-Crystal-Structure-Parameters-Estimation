%%PLOT_COMPARE_OBSERVED_MODELLED Script to plot training and test results of a single experiment 
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
    test_response_obs = result_trained_model.dataset.test.a;

    algorithm_names = {'random forest', 'lsboost', 'neural network', 'regression tree'};

    %% Test    
    f = figure;
    f.Position = [0 0 1920 1000];
    
    subplot(4,1,1);
    plotPerfectFit(test_response_obs, result_trained_model.random_forest.test_results.test_predictions, algorithm_names(1));
    
    subplot(4,1,2);
    plotPerfectFit(test_response_obs, result_trained_model.lsboost.test_results.test_predictions, algorithm_names(2));
    
    subplot(4,1,3);
    plotPerfectFit(test_response_obs, result_trained_model.neural_network.test_results.test_predictions, algorithm_names(3));

    subplot(4,1,4);
    plotPerfectFit(test_response_obs, result_trained_model.regression_tree.test_results.test_predictions, algorithm_names(4));
    
    sgtitle('Test results'); 
end

function [] = plotPerfectFit(obs, pred, modelName)
    if (istable(obs))
        obs = table2array(obs);
    end
    
    if(istable(pred))
        pred = table2array(pred);
    end
    
    x = linspace(1,numel(obs),numel(obs));
    
    plot(x,obs, '-','LineWidth',1.3);
    hold on;
    plot(x,pred,'-','LineWidth',1.3);
    xlim([0 max(x)+1]);
    ylim([0 50]);
    xlabel('Record number');
    ylabel('Salinity (psu)');
    title(modelName);
    legend('Observed','Modelled','Location','northwest');
    set(gca,'FontSize',12);
    grid on;
    hold off;
end