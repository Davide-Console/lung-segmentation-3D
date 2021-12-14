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
%   % Access and visualize lungs from axial view at time = 5s
%   
%   time = 5;
%   lungs_ax_5 = results(time + 1).lungs_ax;
%   scale_factors = [results(time+1).x, results(time+1).y, results(time+1).z];
%   volumeViewer(lungs_ax_5, 'ScaleFactors', scale_factors);
%
%   % Access and visualize mask from axial view at time = 2s
%   
%   time = 2;
%   mask_ax_2 = results(time + 1).mask_ax;
%   scale_factors = [results(time+1).x, results(time+1).y, results(time+1).z];
%   volumeViewer(mask_ax_2, 'ScaleFactors', scale_factors);
%
%   % Access and visualize edges from coronal view at time = 7s
%   
%   time = 7;
%   edges_cor_7 = results(time + 1).edges_cor;
%   % scale factors in different order because of CT permutation
%   scale_factors = [results(time+1).x, results(time+1).z, results(time+1).y]; 
%   volumeViewer(edges_cor_7, 'ScaleFactors', scale_factors);
%
%   % Compare lungs volume between axial and coronal view at time = 0s;
%   
%   time = 0s;
%   ax_vol_0 = results(time + 1).ax_volume;
%   cor_vol_0 = results(time + 1).cor_volume;
%   fprintf("Axial view volume: %.2f liters\nCoronal view volume: %.2f liters\n", ax_vol_0/1e+06, cor_vol_0/1e+06); 

%% 

clc; close all; clear; 

%% Loading data
hWaitBar=waitbar(0,'Processing CTs');

apply_noise = false; % set to false to not apply noise

times = [0 10 20 30 40 50 60 70 80 90];

for time = times

    index = time/10 + 1;
    results(index).time = time/10; %#ok<*SAGROW>
    [CT, infoCT, fileNamesCT, dimCT] = imgload(time);
    results(index).infoCT = infoCT;
    CT = CT(127:337,:,1:70);
    
    % Adding Noise
    noise='salt & pepper';
    noise_density = 0.05;
    if apply_noise == true
        CT_noisy = imnoise(CT, noise, noise_density);
    else
        CT_noisy = CT;
    end

    z_dim = infoCT.SliceThickness;
    x_dim = infoCT.PixelSpacing(1);
    y_dim = infoCT.PixelSpacing(2);
    results(index).x = x_dim; results(index).y = y_dim; results(index).z = z_dim;
    results(index).voxel_dim = x_dim*y_dim*z_dim; % mm^3
    
    mask = roidef(CT_noisy, 'axial', noise_density);
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
    
    mask = roidef(CT_noisy, 'coronal', noise_density);
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
    times = [times results(i).time]; 
    vol_ax = [vol_ax results(i).ax_volume]; %#ok<*AGROW> 
    vol_cor = [vol_cor results(i).cor_volume];
end

figure('Name', 'Volume');
plot(times, vol_ax); hold on; plot(times, vol_cor); plot(times, abs(vol_ax-vol_cor))
legend('Axial View', 'Coronal View', 'abs(Axial Volume - Coronal Volume)', 'Location','best');
ylabel('Volume [mm^3]'); xlabel('Time [s]');


help main

