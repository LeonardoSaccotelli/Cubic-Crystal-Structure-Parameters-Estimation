%% Script to collect all the unit test for 'create_dataset.m' function
function tests = createDatasetTest
    tests = functiontests(localfunctions);
end

%% test 1
function testOneResponse(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = false;
    useTotalNPeaks = false;
    replaceMissingPeaksWithZero = true;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3061 12];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 2
function testNResponse(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a', 'b', 'c', 'alpha', 'beta', 'gamma'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = false;
    useTotalNPeaks = false;
    replaceMissingPeaksWithZero = true;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3061 17];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 3
function testUseMaxPeaks(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = true;
    useTotalNPeaks = false;
    replaceMissingPeaksWithZero = true;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3061 13];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 4
function testUseTotalNPeaks(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = false;
    useTotalNPeaks = true;
    replaceMissingPeaksWithZero = true;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3061 13];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 5
function testAddFeaturesReplaceWithZero(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = true;
    useTotalNPeaks = true;
    replaceMissingPeaksWithZero = true;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3061 14];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 6
function testNotReplaceWithZero(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = false;
    useTotalNPeaks = false;
    replaceMissingPeaksWithZero = false;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3012 12];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 7
function testNotReplaceWithZeroUseMaxPeaks(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = true;
    useTotalNPeaks = false;
    replaceMissingPeaksWithZero = false;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3012 13];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 8
function testNotReplaceWithZeroUseTotalNPeaks(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = false;
    useTotalNPeaks = true;
    replaceMissingPeaksWithZero = false;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3012 13];

    verifyEqual(testCase,actSolution,expSolution)
end

%% test 9
function testNotReplaceWithZeroUseMaxPeaksTotalNPeaks(testCase)
    addpath(genpath('..\..\0-Dataset\1-Merged'));
    addpath(genpath('..\1-pre-processing'));
    data = load("0-Dataset\1-Merged\cubic_merged_dataset.mat");

    response = {'a'};
    nPeaksToKeep = 10;
    threshold = 1;
    useMaxPeaks = true;
    useTotalNPeaks = true;
    replaceMissingPeaksWithZero = false;
    
    actSolution = size(create_dataset(data.Spectrum.X, data.Spectrum.Y, data.Additional_Spectrum_Information, response, ...
        nPeaksToKeep, threshold, useMaxPeaks, useTotalNPeaks, replaceMissingPeaksWithZero));
    
    expSolution = [3012 14];

    verifyEqual(testCase,actSolution,expSolution)
end






