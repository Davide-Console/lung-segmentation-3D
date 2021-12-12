%% 
clc; close all; clear

%% Loading data
[CT, infoCT, fileNamesCT, dimCT] = imgload();

CT = CT(127:337,:,1:70);
%% ROI definition on CT
[~, mask] = roidef(CT, 'coronal');

[Xout, rp] = getLargestCc(mask(:,:,:), 1);

roi = maskout(permute(CT, [3 2 1]), Xout);

volumeViewer(Xout);

sum(sum(sum(Xout)))