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
%   time = 0;
%   ax_vol_0 = results(time + 1).ax_volume;
%   cor_vol_0 = results(time + 1).cor_volume;
%   fprintf("Axial view volume: %.2f liters\nCoronal view volume: %.2f liters\n", ax_vol_0/1e+06, cor_vol_0/1e+06); 

clc; close all; clear; 

%% Noise Selection

response = questdlg('Would you like to apply noise to the CT scans?', ...
	'Noise selection', ...
	'Yes', 'No', 'No');

if strcmp(response, 'Yes')
    apply_noise = true; % set to false not to apply noise
    response = questdlg('Which noise would you like to apply?', ...
	'Noise selection', ...
	'Salt & Pepper', 'Gaussian', 'Salt & Pepper');
    if strcmp(response, 'Gaussian')
        noise = 'gaussian';
    else
        noise = 'salt & pepper';
    end
else
    apply_noise = false;
    noise = 'none';
    noise_att = 0;
end

hWaitBar=waitbar(0,'Processing CTs');


%% Data loading and processing

times = [0 10 20 30 40 50 60 70 80 90];

for time = times

    index = time/10 + 1;
    results(index).time = time/10; %#ok<*SAGROW>
    
    % Loading CT stack and storing header
    [CT, infoCT, fileNamesCT, dimCT] = imgload(time);
    results(index).infoCT = infoCT;
    CT = CT(127:337,:,1:70); % Useless slices removal
    
    % Adding Noise
    if apply_noise == true
        if strcmp(noise, 'salt & pepper')
            noise_att = 0.05;
            CT_noisy = imnoise(CT, noise, noise_att);
        else
            M = 0;
            noise_att = 0.00001;
            CT_noisy = imnoise(CT, 'gaussian', M, noise_att);
        end
    else
        CT_noisy = CT;
    end
    
    % Extracting and storing of voxel dimensions from CT header
    z_dim = infoCT.SliceThickness;
    x_dim = infoCT.PixelSpacing(1);
    y_dim = infoCT.PixelSpacing(2);
    results(index).x = x_dim; results(index).y = y_dim; results(index).z = z_dim;
    results(index).voxel_dim = x_dim*y_dim*z_dim; % mm^3
    
    % Lungs volume detection from axial view
    mask = volumeDetection(CT_noisy, 'axial', noise, noise_att);

    % Extraction of the lungs from the mask. This is an extra step to
    % remove eventual false positive not connected with lungs
    [mask_out, ~] = getLargestCc(mask(:,:,:), 1);
    results(index).mask_ax = mask_out;
    results(index).ax_volume = sum(sum(sum(results(index).mask_ax)))*results(index).voxel_dim;
    % If the two lungs are not connected by the trachea the two largest
    % volume are extracted
    if results(index).ax_volume < 2.2e6
        [mask_out, ~] = getLargestCc(mask(:,:,:), 2); 
        results(index).mask_ax = mask_out;
        results(index).ax_volume = sum(sum(sum(results(index).mask_ax)))*results(index).voxel_dim;
    end

    % Extraction of lungs from the original CT stack based on pixel = true
    % in mask_out
    results(index).lungs_ax = maskout(CT, mask_out);

    % Edge detection on the mask
    results(index).edges_ax = edge_detection(results(index).mask_ax);
    
    waitbar((time)/95);

    % Lungs volume detection from coronal view
    mask = volumeDetection(CT_noisy, 'coronal', noise, noise_att);
    [mask_out, ~] = getLargestCc(mask(:,:,:), 1); 
    results(index).mask_cor = mask_out;
    results(index).cor_volume = sum(sum(sum(results(index).mask_cor)))*results(index).voxel_dim;
    if results(index).cor_volume < 1.8e6
        [mask_out, ~] = getLargestCc(mask(:,:,:), 2); 
        results(index).mask_cor = mask_out;
        results(index).cor_volume = sum(sum(sum(results(index).mask_cor)))*results(index).voxel_dim;
    end

    % Extraction of lungs from the original CT stack based on pixel = true
    % in mask_out. CT is permuted to bring coronal view in the XY plane
    results(index).lungs_cor = maskout(permute(CT, [3 2 1]), mask_out);
    results(index).edges_cor = edge_detection(results(index).mask_cor);
    
    waitbar((time+5)/95);
    
end
delete(hWaitBar);


%% time-volume plot
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

