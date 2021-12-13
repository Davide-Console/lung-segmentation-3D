% imgload returns a CT stack, CT header, filenames containing the slices
% and dimension of the stack
%
% Inputs:
% -------
%   time - time instance of the CT to be load
%
% Outputs:
% --------
%   data - 3-D array with CT pixels
%   info - header of the CT scan
%   names - list of filenames of the CT stack
%   dim - dimensions of the stack
function [data, info, names, dim] = imgload (time)
    id ='images:dicominfo:fileVRDoesNotMatchDictionary';
    warning('off',id)
    fileFolder=fullfile(pwd,strcat('dataset/T_', int2str(time), '/CT'));
    
    files=dir(fullfile(fileFolder,'*.dcm'));
    names={files.name};
    [~, reindex] = sort( str2double(regexp({files.name}, '\d+', 'match', 'once' )));
    names = names(reindex) ;
    
    info = dicominfo(fullfile(fileFolder,names{1}));

    I=dicomread(fullfile(fileFolder,names{1}));
    type=class(I);
    dim=size(I);
    numImgs=length(names);
    data = zeros(dim(1),dim(2),numImgs,type);
   
    for i=length(names):-1:1
        fname=fullfile(fileFolder,names{i});
        data(:,:,i)=uint16(dicomread(fname));
    end
end

