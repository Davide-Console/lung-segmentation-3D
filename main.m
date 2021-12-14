% main
%
% View results:
%
% All the results are stored in the results struct.
% fields are:
%   - time: stores the time instance of the CT scan.
%   - voxel_dim: stores the voxel dimension extracted from the dcm header.
%   - mask_ax: stores a 3D-logical-matrix with pixel = true where lungs
%   have been segmented from the axial view.
%   - ax_volume: stores the volume (in mm^3) of the segmented lungs from
%   the axial view.
%   - lungs_ax: stores a 3D-matrix showing only the original pixel of the
%   CT scan where lungs have been detected from the axial view.
%   - edegs_ax: stores a 3D-logical-matrix with pixel = true where lungs'
%   edges have been detected from the axial view.
%   - mask_cor: stores a 3D-logical-matrix with pixel = true where lungs
%   have been segmented from the coronal view.
%   - cor_volume: stores the volume (in mm^3) of the segmented lungs from
%   the coronal view.
%   - lungs_cor: stores a 3D-matrix showing only the original pixel of the
%   CT scan where lungs have been detected from the coronal view.
%   - edegs_cor: stores a 3D-logical-matrix with pixel = true where lungs'
%   edges have been detected from the axial view. 
%   
%   - Keep in mind that for coronal view volumes have been permuted: 
%   to visualize coronal view with volumeViewer select the 'XY Slice' view.
%
%   % Examples on how to visualize results:
%
%   % Access and visualize lungs from axial view at time = 50
%   
%   time = 50;
%   lungs_ax_50 = results(time/10 + 1).lungs_ax;
%   volumeViewer(lungs_ax_50);
%
%   % Access and visualize mask from axial view at time = 20
%   
%   time = 20;
%   mask_ax_20 = results(time/10 + 1).mask_ax;
%   volumeViewer(mask_ax_20);
%
%   % Access and visualize edges from coronal view at time = 70
%   
%   time = 70;
%   edges_cor_70 = results(time/10 + 1).edges_cor;
%   volumeViewer(edges_cor_70);
%
%   % Compare lungs volume between axial and coronal view at time = 0;
%   
%   time = 0;
%   ax_vol_0 = results(time/10 + 1).ax_volume;
%   cor_vol_0 = results(time/10 + 1).cor_volume;
%   fprintf("Axial view volume: %.2f liters\nCoronal view volume: %.2f liters\n", ax_vol_0/1e+06, cor_vol_0/1e+06); 

%% 

clc; close all; clear; 

%% Loading data
hWaitBar=waitbar(0,'Processing CTs');

apply_noise = false; % set to false not to apply noise

if apply_noise == false
    noise = 'none';
    noise_att = 0;
end

% If apply_noise is set to true, please select the noise we would like to
% test:

% noise = 'salt & pepper';
% noise = 'gaussian';

for time = 0:10:90

    index = time/10 + 1;
    results(index).time = time; %#ok<*SAGROW> 
    [CT, infoCT, fileNamesCT, dimCT] = imgload(time);
    CT = CT(127:337,:,1:70);
    
    % Adding Noise
    if apply_noise == true
        if strcmp(noise, 'salt & pepper')
            noise_att = 0.05;
            CT_noisy = imnoise(CT, noise, noise_density);
        else
            M = 0;
            noise_att = 0.00001;
            CT_noisy = imnoise(CT, 'gaussian', M, noise_att);
        end
    else
        CT_noisy = CT;
    end

    z_dim = infoCT.SliceThickness;
    x_dim = infoCT.PixelSpacing(1);
    y_dim = infoCT.PixelSpacing(2);
    results(index).voxel_dim = x_dim*y_dim*z_dim; % mm^3
    
    mask = roidef(CT_noisy, 'axial', noise, noise_att);
    [mask_out, ~] = getLargestCc(mask(:,:,:), 1);
    results(index).mask_ax = mask_out;
    results(index).ax_volume = sum(sum(sum(results(index).mask_ax)))*results(index).voxel_dim;
    if results(index).ax_volume < 2.2e6
        [mask_out, ~] = getLargestCc(mask(:,:,:), 2); 
        results(index).mask_ax = mask_out;
        results(index).ax_volume = sum(sum(sum(results(index).mask_ax)))*results(index).voxel_dim;
    end
    results(index).lungs_ax = maskout(CT, mask_out);
    results(index).edges_ax = edge_detection(results(index).mask_ax);
    
    mask = roidef(CT_noisy, 'coronal', noise, noise_att);
    [mask_out, ~] = getLargestCc(mask(:,:,:), 1); 
    results(index).mask_cor = mask_out;
    results(index).cor_volume = sum(sum(sum(results(index).mask_cor)))*results(index).voxel_dim;
    if results(index).cor_volume < 1.8e6
        [mask_out, ~] = getLargestCc(mask(:,:,:), 2); 
        results(index).mask_cor = mask_out;
        results(index).cor_volume = sum(sum(sum(results(index).mask_cor)))*results(index).voxel_dim;
    end
    results(index).lungs_cor = maskout(permute(CT, [3 2 1]), mask_out);
    results(index).edges_cor = edge_detection(results(index).mask_cor);
    
    waitbar(time/90);
    
end
delete(hWaitBar);


%% volume plot
times = [];
vol_ax = [];
vol_cor = [];
for i = 1:length(results)
    times = [times results(i).time]; %#ok<*AGROW> 
    vol_ax = [vol_ax results(i).ax_volume];
    vol_cor = [vol_cor results(i).cor_volume];
end

figure('Name', 'Volume');
plot(times, vol_ax); hold on; plot(times, vol_cor); plot(times, abs(vol_ax-vol_cor))
legend('Axial View', 'Coronal View', 'abs(Axial Volume - Coronal Volume)', 'Location','best');
ylabel('Volume [mm^3]'); xlabel('Time [s]');


help main

