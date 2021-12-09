%% Clear workspace
clear; clc; close all;

%% choose subject(s) to analyze

% list = {'0','10','20','30','40', '50', '60', '70', '80', '90'};
% [time ,selected] = listdlg('ListString', list, 'ListSize', [120, 90], 'PromptString', "Subject Selection");
% 
% if ~selected
%     error('You have to make at least one choice to procede');
% end

% qua metteremo il for per ogni selection
subjects = [];

f = waitbar(0, sprintf('Loading:  %u / %u', 0, 90));
for i = 0:10:90
    waitbar(i/90, f, sprintf('Loading:  %u / %u', i, 90));
    [subject.data, subject.info] = readDCMfolder(i);
    subjects = [subjects; [subject]]; %#ok<NBRAK,*AGROW> 
end
clear subject; close(f);

%% preprocessing

% removing ~ROI 

for i = 1:length(subjects)
    subjects(i).data = subjects(i).data(127:337, 120:422, 1:72); %#ok<*SAGROW> 
end

subject_to_analyze = 1;
Ls = subjects(subject_to_analyze);
%% load single slice
for z = 1:size(subjects(subject_to_analyze).data,3)
    img = squeeze(subjects(subject_to_analyze).data(:,:,z));
    imshow(img, []);
    
    %% bring img to double
    
    img = img/max(max(img));
    
    LOW_in = min(img(:));
    HIGH_in = max(img(:));
    img = imadjust(img, [LOW_in HIGH_in]);
    % imshow(img, []);
    
    %% contrast adjustments
    %figure();
    %imhist(img);
    hist_pre = imhist(img);
    LOW_in = 0.0;
    HIGH_in = 1.0;
    threshold = 65;
    for i = length(hist_pre):-1:1
        if hist_pre(i) < 65
            HIGH_in = i;
        else
            break
        end
    end
    HIGH_in = HIGH_in/255;
    img = imadjust(img, [LOW_in HIGH_in], [0.0 1.0], 0.5);
    %figure();
    %imhist(img);
    
    %% background adjustments
    
    img = fill_area(img, 1, 1, 0.3, 0.3, 0.4, 1.0);
    img = fill_area(img, 1, size(img, 2), 0.3, 0.3, 0.4, 1.0);
    img = fill_area(img, size(img,1), 1, 0.3, 0.3, 0.4, 1.0);
    img = fill_area(img, size(img, 1), size(img, 2), 0.3, 0.3, 0.4, 1.0);
    
    %%
    img = im2uint8(img);
    [L,Centers] = imsegkmeans(img,2);
    lungs_val = min(Centers); % estraggo il centroide che contiene i polmoni
    
    B = labeloverlay(img,L);
    %figure();
    %imshow(B)
    if lungs_val == Centers(1)
        L = L == 1;
    else
        L = L == 2;
    end
    L = L+1;
    Ls.data(:,:,z) = L;
end
volumeViewer(subjects(subject_to_analyze).data, Ls.data);