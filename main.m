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
    subjects = [subjects; [subject]]; %#ok<*AGROW> 
end
clear subject; close(f);

%% preprocessing

% removing ~ROI 

for i = 1:length(subjects)
    subjects(i).data = subjects(i).data(127:337, 120:422, 1:72); %#ok<*SAGROW> 
end
