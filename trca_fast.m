function [W,V] = trca_fast(eeg)
% Task-related component analysis (TRCA). This script was written based on
% the reference paper [1].
%
% function W = trca(eeg)
%
% Input:
%   eeg         : Input eeg data 
%                 (# of channels, Data length [sample], # of trials)
%
% Output:
%   W           : Weight coefficients for electrodes which can be used as 
%                 a spatial filter.
%   
% Reference:
%   [1] H. Tanaka, T. Katura, H. Sato,
%       "Task-related component analysis for functional neuroimaging and 
%        application to near-infrared spectroscopy data",
%       NeuroImage, vol. 64, pp. 308-327, 2013.
%
% Masaki Nakanishi, 22-Dec-2017
% Swartz Center for Computational Neuroscience, Institute for Neural
% Computation, University of California San Diego
% E-mail: masaki@sccn.ucsd.edu

% trca_fast(): TRCA with fast calculation speed
% Chi Man Wong, 6-Apr-2021


X1 = eeg(:,:);
X2 = sum(eeg,3);
S = X2*X2';
Q = X1*X1';

% TRCA eigenvalue algorithm
[eig_vec,eig_val] = eig(Q\S);
[V,sort_idx]=sort(diag(eig_val),'descend');
W=eig_vec(:,sort_idx);
end
