# Cubic-Crystal-Structure-Parameters-Estimation
Preliminary investigation of machine learning techniques to perform parameters estimation for the crystal structure of type: <b>cube</b>.
Starting from a spectral, which represent a cubic crystal structure, the aim is to develop a ML model which can predict the three different parameters size: <i>a</i>, <i>b</i>, <i>c</i>. 
Each observation is a couple (x<sub>i</sub>, y<sub>i</sub>), for which x<sub>i</sub> is a value between 0 and 90, with an increment of 0.02; y<sub>i</sub> is the intensity. 
For the cubic structure the three dimensions are all equal; thus, for the cubic structure is a one-output regression problem. <br> Different ML algorithms have been implemented, such as: Regression Tree, Random Forest, LSBoost, Neural Network.
Three different experiment have been runned. 1

## Experiment #1
To run the <b>Experiment #1:</b> 
````
 run_experiment.m
````
In the experiment 1, the user can set different before running the experiment. In particular:
* threshold, such that a peak in the spectrum coulb be selected
* the number of the first N peaks (greater than the threshold)
  * in this experiment only the position (NOT the intensity) of these peaks are used as features for the model training
* if the position of the biggest peak should be used or not as feature
* if the total number of peaks should be used or not as feature
* if the missing value should be replaced or not<br>
Then, the experiment is runned with the selected settings. 

## Experiment #2
To run the <b>Experiment #2:</b> 
````
 run_iteration_experiment.m
````
In the experiment 2, the settings are frozen. In particular:
* threshold = 1
* the numbers of the first N peaks (greater than the threshold) is <b>fixed</b> to [[10 15 20 25 30 40 50]]
  * in this experiment only the position (NOT the intensity) of these peaks are used as features for the model training
* if the position of the biggest peak should be used or not as feature (NOT USED)
* if the total number of peaks should be used or not as feature (USED)
* if the missing value should be replaced or not (NOT)<br>
Then, the experiment is runned for each number of peaks and a comparison of the performances is provided. 

## Experiment #3
To run the <b>Experiment #3:</b> 
````
 run_experiment_using_all_spectrum_data.m
````
In the experiment 3, instead of using the position of the first N peaks, we used the entire spectrum data, which are all the y<sub>i</sub> as features to train the models.


## Prerequisites
* MATLAB Version 9.14 (R2023a) (https://it.mathworks.com/products/matlab.html)
* Statistics and Machine Learning Toolbox Version 12.5 (R2023a) (https://it.mathworks.com/products/statistics.html)
* Parallel Computing Toolbox Version 7.8 (R2023a) (https://it.mathworks.com/products/parallel-computing.html)
