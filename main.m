%% 
clc; close all; clear

%% Loading data
[CT, infoCT, fileNamesCT, dimCT] = imgload();

CT = CT(:,:,1:70);
%% ROI definition on CT
[roi, mask] = roidef(CT);

[Xout, rp] = getLargestCc(mask(:,:,:), 1);

volumeViewer(Xout);

