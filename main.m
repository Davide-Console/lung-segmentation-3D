%% 
clc; close all; clear

%% Loading data
[CT, infoCT, fileNamesCT, dimCT] = imgload();

CT = CT(127:337,:,1:70);
%% Adding Noise
noise='salt & pepper';
noise_density = 0.05; % 0 0.2 0.35

CT = imnoise(CT, noise, noise_density);

%% ROI definition on CT
view = 'coronal'; %'axial'

[~, mask] = roidef(CT, view, noise_density);

[Xout, rp] = getLargestCc(mask(:,:,:), 1);

if strcmp(view, 'axial')
    roi = maskout(CT, Xout);
elseif strcmp(view, 'coronal')
    roi = maskout(permute(CT, [3 2 1]), Xout);
end

volumeViewer(Xout);

sum(sum(sum(Xout)))

