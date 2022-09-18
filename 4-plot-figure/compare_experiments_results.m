%%COMPARE_EXPERIMENTS_RESULTS Script to compare results of differente experiment using different number of peaks
addpath(genpath('..\3-trained-models'));
addpath(genpath('..\7-utils'));

exp1 = load("..\3-trained-models\exp-improv-plus-per-second\Exp_1_cubic_10peaks_1threshold_NOnPeaks_NOmaxPeak_NOreplace.mat");
exp2 = load("..\3-trained-models\exp-improv-plus-per-second\Exp_2_cubic_10peaks_1threshold_NOnPeaks_YESmaxPeak_NOreplace.mat");
exp3 = load("..\3-trained-models\exp-improv-plus-per-second\Exp_3_cubic_10peaks_1threshold_YESnPeaks_NOmaxPeak_NOreplace.mat");
exp4 = load("..\3-trained-models\exp-improv-plus-per-second\Exp_4_cubic_10peaks_1threshold_YESnPeaks_YESmaxPeak_NOreplace.mat");
exp5 = load("..\3-trained-models\exp-improv-plus-per-second\Exp_5_cubic_10peaks_1threshold_NOnPeaks_NOmaxPeak_YESreplace.mat");

t_exp1 = reshapeTable(exp1.result_trained_model.summary_metrics.test_metrics);
t_exp2 = reshapeTable(exp2.result_trained_model.summary_metrics.test_metrics);
t_exp3 = reshapeTable(exp3.result_trained_model.summary_metrics.test_metrics);
t_exp4 = reshapeTable(exp4.result_trained_model.summary_metrics.test_metrics);
t_exp5 = reshapeTable(exp5.result_trained_model.summary_metrics.test_metrics);

legendName = {'Exp 1: 10 peaks, 1 threshold, N nPeaks, N maxPeak, N replace 0',...
    'Exp 2: 10 peaks, 1 threshold, N nPeaks, Y maxPeak, N replace 0', ...
    'Exp 3: 10 peaks, 1 threshold, Y nPeaks, N maxPeak, N replace 0',...
    'Exp 4: 10 peaks, 1 threshold, Y nPeaks, Y maxPeak, N replace 0',...
    'Exp 5: 10 peaks, 1 threshold, N nPeaks, N maxPeak, Y replace 0'};


for i = 2:width(t_exp1)
    subplot(2,2, i-1);
    x = [table2array(t_exp1(:,i)) table2array(t_exp2(:,i)) ...
        table2array(t_exp3(:,i))  table2array(t_exp4(:,i)) table2array(t_exp5(:,i))];
    bar(x);
    title( strrep(t_exp1.Properties.VariableNames(i),'_',' '));
    xticklabels( t_exp1.OriginalVariableNames);
    ylim([0 11]);
    xlabel('Metrics');
    ylabel('Performance');
    set(gca,'FontSize',12);
    legend(legendName,"FontSize",9);
end


function [t] = reshapeTable (t)
    t = rows2vars(t);
end
