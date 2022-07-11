%%COMPARE_EXPERIMENTS_RESULTS Script to compare results of differente experiment using different number of peaks

addpath(genpath('..\3-trained-models'));
addpath(genpath('..\7-utils'));

exp1 = load("..\3-trained-models\cubic_10peaks_1threshold_noAdd_Feat.mat");
exp2 = load("..\3-trained-models\cubic_10peaks_1threshold_MaxPeaksUsed_NoReplaceWithZero.mat");
exp3 = load("..\3-trained-models\cubic_10peaks_1threshold_NTotalPeaksUsed_NoReplaceWithZero.mat");
exp4 = load("..\3-trained-models\cubic_10peaks_1threshold_MaxPeaks_NTotalPeaks_Used_NoReplaceWithZero.mat");
exp5 = load("..\3-trained-models\cubic_10peaks_1threshold_noAdd_Feat_replaceWithZero.mat");

t_exp1 = reshapeTable(exp1.result_trained_model.summary_metrics.test_metrics);
t_exp2 = reshapeTable(exp2.result_trained_model.summary_metrics.test_metrics);
t_exp3 = reshapeTable(exp3.result_trained_model.summary_metrics.test_metrics);
t_exp4 = reshapeTable(exp4.result_trained_model.summary_metrics.test_metrics);
t_exp5 = reshapeTable(exp5.result_trained_model.summary_metrics.test_metrics);

legendName = {'Experiment 1: 10 peaks, 1 threshold, noAddFeatures, noReplaceWithZero',...
    'Experiment 2: 10 peaks, 1 threshold, MaxPeaksUsed, noReplaceWithZero', ...
    'Experiment 3: 10 peaks, 1 threshold, NTotalPeaksUsed, noReplaceWithZero',...
    'Experiment 4: 10 peaks, 1 threshold, MaxPeaks-NTotalPeaksUsed, noReplaceWithZero',...
    'Experiment 5: 10 peaks, 1 threshold, noAddFeatures, ReplaceWithZero'};


for i = 2:width(t_exp1)
    subplot(2,2, i-1);
    x = [table2array(t_exp1(:,i)) table2array(t_exp2(:,i)) ...
        table2array(t_exp3(:,i))  table2array(t_exp4(:,i)) table2array(t_exp5(:,i))];
    bar(x);
    title( strrep(t_exp1.Properties.VariableNames(i),'_',' '));
    xticklabels( t_exp1.OriginalVariableNames);
    ylim([0 4]);
    xlabel('Metrics');
    ylabel('Performance');
    legend(legendName);
    set(gca,'FontSize',12);
end


function [t] = reshapeTable (t)
    t = rows2vars(t);
end
