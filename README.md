# Comparison-between-two-implementation-approaches-of-TRCA-in-Matlab
Recently, the task-related component analysis (TRCA) is widely used in the SSVEP recognition.  Here I compare two implementation approaches of TRCA in Matlab. One is proposed by Masaki Nakanishi in https://github.com/mnakanishi/TRCA-SSVEP/tree/master/src. Based on this version, I propose a new version which has a shorter calculation time.

The main difference between them is that the former uses the FOR-loop to calculate the covariance matrix and the latter uses the matrix computation to calculate the covariance matrix. As we know that Matlab is better to do the calculation using the matrix computation than using the FOR-loop, the latter may do the calculation faster.

## Using FOR-loop
It calculates the summation of the covariance matrices between any two trials in the FOR loops (i.e., S and Q), as shown in the following code:
```
%     eeg         : Input eeg data 
%                 (# of channels, Data length [sample], # of trials)
for trial_i = 1:1:num_trials-1
    x1 = squeeze(eeg(:,:,trial_i));    
    for trial_j = trial_i+1:1:num_trials
        x2 = squeeze(eeg(:,:,trial_j));        
        S = S + x1*x2' + x2*x1';
    end % trial_j
end % trial_i
UX = reshape(eeg, num_chans, num_smpls*num_trials);
UX = bsxfun(@minus, UX, mean(UX,2));
Q = UX*UX';
```

(More details can be found in trca.m)

## Using matrix computation
```
%     eeg         : Input eeg data 
%                 (# of channels, Data length [sample], # of trials)
X1 = eeg(:,:);
X2 = sum(eeg,3);
S = X2*X2';
Q = X1*X1';
```

(More details can be found in trca_fast.m)

In mathematics, these two calculations are equivalent if each trial data has zero mean (please refer to the paper 'Spatial Filtering in SSVEP-Based BCIs: Unified Framework and New Improvements' in https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=9006809 or https://www.researchgate.net/publication/339417095_Spatial_Filtering_in_SSVEP-based_BCIs_Unified_Framework_and_New_Improvements)

The following two figures show the difference between their calculation time under different number of trials and the difference between their calculated eigen vectors, respectively.

![image](https://github.com/edwin465/Comparison-between-two-implementation-approaches-of-TRCA-in-Matlab/blob/main/cal_time.png)
Clearly, their calculation times have large difference， especially when the number of trials is more than 10.

![image](https://github.com/edwin465/Comparison-between-two-implementation-approaches-of-TRCA-in-Matlab/blob/main/cal_error.png)
Their eigen vectors have no difference.

In this comparison, we assume that each trial data is center. 
Anyway, according to my experience, whether the trial data is centralized or not does not have much difference in the SSVEP recognition performance using the TRCA algorithm.


