# Cubic-Crystal-Structure-Parameters-Estimation
Preliminary investigation of machine learning techniques to perform parameters estimation for the crystal structure of type: <b>cube</b>.
Starting from a spectral, which represent a cubic crystal structure, the aim is to develop a ML model which can predict the three different parameters size: <i>a</i>, <i>b</i>, <i>c</i>. 
Each observation is a couple (x<sub>i</sub>, y<sub>i</sub>), for which x<sub>i</sub> is a value between 0 and 90, with an increment of 0.02; y<sub>i</sub> is the intensity. 
For the cubic structure the three dimensions are all equal; thus, for the cubic structure is a one-output regression problem. <br> Different ML algorithms have been implemented, such as: Regression Tree, Random Forest, LSBoost, Neural Network.
Three different experiment have been runned. 

## Experiment #1
In the experiment 1, the user can set different before running the experiment. In particular:
Project is organized as follow:
* ```/Machine-Learning-Tools/```
  * ```/ Machine-Learning-Tools / 1-Utility /```
  * ```/ Machine-Learning-Tools / 2-Machine-Learning-Function /```  
  * ```/ Machine-Learning-Tools / 3-Plot-Figure /```
* ```/Parameters-Estimation/```
  * ```/ Parameters-Estimation / Lx_Parameters_Estimation /```
  * ```/ Parameters-Estimation / Ck_Parameters_Estimation /```  
  * ```/ Parameters-Estimation / Salinity_Estimation /```
  * ```/ Parameters-Estimation / Hybrid_Model_Predictions /```

## Prerequisites
* MATLAB Version 9.14 (R2023a) (https://it.mathworks.com/products/matlab.html)
* Statistics and Machine Learning Toolbox Version 12.5 (R2023a) (https://it.mathworks.com/products/statistics.html)
* Parallel Computing Toolbox Version 7.8 (R2023a) (https://it.mathworks.com/products/parallel-computing.html)

## Running the experiments
To run the experiment to train the salt wedge intrusion length (L<sub>x</sub>) ML models:
````
/ Parameters-Estimation / Lx_Parameters_Estimation / run_experiment_train_2003_2012_test_2013_2017.m
````
To run the experiment to train the non-dimensional eddy diffusivity coefficient (C<sub>k</sub>) ML models:

````
/ Parameters-Estimation / Ck_Parameters_Estimation / run_experiment_training_test_2016_2019.m
````
To run the experiment to train the salinity ML models:

````
/ Parameters-Estimation / Salinity_Estimation / run_experiment_training_test_2016_2019.m
````
