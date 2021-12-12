%% 
clc; close all; clear

%% Loading data
[CT, infoCT, fileNamesCT, dimCT] = imgload();

%% ROI definition on CT
[roi] = roidef(CT);

volumeViewer(roi);

