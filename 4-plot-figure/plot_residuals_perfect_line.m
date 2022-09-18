%%PLOT_RESIDUALS_PERFECT_LINE Script to plot training and test results of a single experiment 
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
    response = 'a';

    training_response_obs = table2array(result_trained_model.dataset.training(:,response));
    training_id = table2array(result_trained_model.dataset.training(:,"Id"));

    
    %% Training results
    f = figure;
    f.Position = [0 0 1920 1000];

    subplot(2,4,1);
    plotPerfectFit(training_response_obs, result_trained_model.random_forest.validation_results.validation_predictions, algorithm_names(1));
    
    subplot(2,4,2);
    plotPerfectFit(training_response_obs, result_trained_model.lsboost.validation_results.validation_predictions, algorithm_names(2));

    subplot(2,4,3);
    plotPerfectFit(training_response_obs, result_trained_model.neural_network.validation_results.validation_predictions, algorithm_names(3));

    subplot(2,4,4);
    plotPerfectFit(training_response_obs, result_trained_model.regression_tree.validation_results.validation_predictions, algorithm_names(4));
  
    subplot(2,4,5);
    resumeTable = createResumeTable(training_response_obs, result_trained_model.random_forest.validation_results.validation_predictions, response, training_id);
    plotResidualBar(resumeTable, algorithm_names(1), response);

    subplot(2,4,6);
    resumeTable = createResumeTable(training_response_obs, result_trained_model.lsboost.validation_results.validation_predictions, response, training_id);
    plotResidualBar(resumeTable, algorithm_names(2), response);

    subplot(2,4,7);
    resumeTable = createResumeTable(training_response_obs, result_trained_model.neural_network.validation_results.validation_predictions, response, training_id);
    plotResidualBar(resumeTable, algorithm_names(3), response);

    subplot(2,4,8);
    resumeTable = createResumeTable(training_response_obs, result_trained_model.regression_tree.validation_results.validation_predictions, response, training_id);
    plotResidualBar(resumeTable, algorithm_names(4), response);

    sgtitle('Training results using 10 peaks with threshold = 1');

    %figure;
    %plotRealObs(training_response_obs);   

    %% Test results
    test_response_obs = table2array(result_trained_model.dataset.test(:,response));
    test_id = table2array(result_trained_model.dataset.test(:,"Id"));
    
    f = figure;
    f.Position = [0 0 1920 1000];
    
    subplot(2,4,1);
    plotPerfectFit(test_response_obs, result_trained_model.random_forest.test_results.test_predictions, algorithm_names(1));
    
    subplot(2,4,2);
    plotPerfectFit(test_response_obs, result_trained_model.lsboost.test_results.test_predictions, algorithm_names(2));

    subplot(2,4,3);
    plotPerfectFit(test_response_obs, result_trained_model.neural_network.test_results.test_predictions, algorithm_names(3));

    subplot(2,4,4);
    plotPerfectFit(test_response_obs, result_trained_model.regression_tree.test_results.test_predictions, algorithm_names(4));
  
    subplot(2,4,5);
    resumeTable = createResumeTable(test_response_obs, result_trained_model.random_forest.test_results.test_predictions, response, test_id);
    plotResidualBar(resumeTable, algorithm_names(1), response);

    subplot(2,4,6);
    resumeTable = createResumeTable(test_response_obs, result_trained_model.lsboost.test_results.test_predictions, response, test_id);
    plotResidualBar(resumeTable, algorithm_names(2), response);

    subplot(2,4,7);
    resumeTable = createResumeTable(test_response_obs, result_trained_model.neural_network.test_results.test_predictions, response, test_id);
    plotResidualBar(resumeTable, algorithm_names(3), response);

    subplot(2,4,8);
    resumeTable = createResumeTable(test_response_obs, result_trained_model.regression_tree.test_results.test_predictions, response, test_id);
    plotResidualBar(resumeTable, algorithm_names(4), response);

    sgtitle('Test results using 10 peaks with threshold = 1');
    
    %figure;
    %plotRealObs(test_response_obs);
    
end

function [] = plotPerfectFit(obs, pred, modelName)
    if (istable(obs))
        obs = table2array(obs);
    end

    if(istable(pred))
        pred = table2array(pred);
    end
    plot(obs,pred, '.','MarkerSize',18, ...
        'MarkerFaceColor',[0.00,0.45,0.74],'MarkerEdgeColor','auto');
    hold on;
    xy = linspace(0, 50,50 );
    plot(xy,xy,'k-','LineWidth',1.3);
    xlim([0 50]);
    ylim([0 50]);
    xlabel('True response');
    ylabel('Predicted response');
    title(modelName);
    legend('Observations','Perfect prediction','Location','northwest');
    set(gca,'FontSize',12);
    grid on;
    hold off;
end

function [] = plotResidualBar(resumeTable,modelName, response)
    obs = resumeTable(:,response);
    pred = resumeTable.Predicted;

    if (istable(obs))
        obs = table2array(obs);
    end

    if(istable(pred))
        pred = table2array(pred);
    end
    
    index = linspace(0, height(resumeTable), height(resumeTable));

    hold on;
    plot(index, obs, '.','LineWidth',0.5, 'Color',[0.00,0.45,0.74], ...
        'MarkerSize',18, 'MarkerEdgeColor','auto');
    plot(index, pred, '.','LineWidth',0.5, 'Color',[0.93,0.69,0.13], ...
        'MarkerSize',18, 'MarkerEdgeColor','auto');
    
    for i = 1 : numel(index)
        plot([index(i), index(i)], [obs(i), pred(i)], ...
            'Color', [0.85,0.33,0.10], 'LineWidth', 1,  ...
            'MarkerSize',6, 'MarkerEdgeColor','auto');
    end
    
    xlim([0 max(index)+5]);
    ylim([0 50]);
    legend('True','Predicted','Errors','Location','northwest');
    xlabel('Record number');
    ylabel('Response');
    title(modelName);
    set(gca,'FontSize',12);
    grid on;
    box on;
    hold off;
end

function [] = plotRealObs(obs)
    if (istable(obs))
        obs = table2array(obs);
    end
    
    obs = sort(obs);
    plot(obs, '.','LineWidth',0.5, 'Color',[0.00,0.45,0.74], ...
        'MarkerSize',18, 'MarkerEdgeColor','auto');
    
    xlim([0 max(numel(obs))+5]);
    ylim([0 50]);
    legend('Observations','Location','northwest');
    xlabel('Record number');
    ylabel('Observation');
    title('Observations distribution');
    grid on;
end

function [resumeTable] = createResumeTable(obs, pred, response, id)
    resumeTable = array2table([obs pred abs(obs - pred)],...
        'VariableNames',{response,'Predicted','Residuals'} );
    resumeTable.ID = id;
    resumeTable = sortrows(resumeTable,response,{'ascend'});
end
