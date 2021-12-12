%% 
clc; close all; clear

%% Loading data
[CT, infoCT, fileNamesCT, dimCT] = imgload();

%% ROI definition on CT
[roi, fileNamesroi] = roidef(fileNamesCT, CT, dimCT);

volumeViewer(roi);

