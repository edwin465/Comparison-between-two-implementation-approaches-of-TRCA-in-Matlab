# Comparison-between-two-implementation-approaches-of-TRCA-in-Matlab
One of the state-of-the-art algorithms used in the SSVEP recognition is the task-related component analysis (TRCA). Here I compare two implementation approaches of TRCA in Matlab. One is implemented by Masaki Nakanishi in https://github.com/mnakanishi/TRCA-SSVEP/tree/master/src(see trca.m). Based on this version, I propose a new implementation approach, which has a shorter calculation time, see trca_fast.m.

The main difference between them is that the function trca() uses the FOR-loop to calculate the covariance matrix and the trca_fast() uses the matrix computation to calculate the covariance matrix. As we know that Matlab is better to do the calculation using the matrix computation than using the FOR-loop, the trca_fast() may do the calculation faster.

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
Q = UX*UX';
```

(More details can be found in trca.m)

## Using matrix computation
It calculates S and Q based on the matrix multiplication of two matrices, as shown in the following code:
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

# Comparison study
We count the calculate time of trca() and trca_fast(). Then we compare their calculation times and their calculated eigenvectors. The following two figures show the difference between their calculation time under different number of trials and the difference between their calculated eigenvectors, respectively. The code can be found in comparison_trca_trca_fast.m

![image](https://github.com/edwin465/Comparison-between-two-implementation-approaches-of-TRCA-in-Matlab/blob/main/cal_time.png)
Clearly, their calculation times have large difference，especially when the number of trials is more than 10. 

![image](https://github.com/edwin465/Comparison-between-two-implementation-approaches-of-TRCA-in-Matlab/blob/main/cal_error.png)
Their eigenvectors have no difference.

In this comparison, we assume that each trial data is center. So in the trca.m, there is no action to remove the mean value.

Anyway, according to my experience, whether the trial data is centralized or not does not have much difference in the SSVEP recognition performance using the TRCA algorithm. After preprocessing, the mean of the pre-processed data may be very small or close to zero.

# Summary and Discussion
- If the number of trials is not large, there is no difference between using trca() and trca_fast(). No need to use trca_fast(). Actually, a subject's calibration trials is usually less than 6 in two widely used public SSVEP datasets, e.g., https://www.frontiersin.org/articles/10.3389/fnins.2020.00627/full and https://ieeexplore.ieee.org/document/7740878. 
- For some SSVEP datasets, the number of calibration trials is more than 20, e.g., https://www.mdpi.com/1424-8220/21/4/1256 and https://academic.oup.com/gigascience/article/8/5/giz002/5304369. In this case, using the trca_fast() can speed up the calibration.
- Several recent studies have interest in the cross-subject scenario, e.g., in https://iopscience.iop.org/article/10.1088/1741-2552/abcb6e/meta. The number of trials is usually very large. In this case, it is strongly recommended to use the trca_fast().

# Citation:
If you use this code for a publication, please cite the following paper: 

@article{wong2020spatial,

   title={Spatial Filtering in SSVEP-based BCIs: Unified Framework and New Improvements},
   
   author={Wong,Chi Man and Wang, Boyu and Wang, Ze and Lao, Ka Fai and Rosa, Agostinho and Wan, Feng},
   
   title={{S}patial {F}iltering in {SSVEP}-based {BCI}s: {U}nified {F}ramework and {N}ew {I}mprovements},
   
   journal=IEEE Trans. Biomed. Eng.,
   
   volume={67},
   
   number={11},
   
   pages={3057 --3072},
   
   year={2020},
   
   publisher={IEEE}
   
}

# Contact:

Please email me (chiman465@gmail.com) if you find any mistakes and problems about it.

