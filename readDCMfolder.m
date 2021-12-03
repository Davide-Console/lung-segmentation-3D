function [ vol,info ] = readDCMfolder(time)

% Place the current directory in the folder containing single .dcm files.

%%

cd(strcat('dataset/T_', int2str(time), '/CT/'))
D = dir('*.dcm');

im = dicomread( D(1).name );
vol = zeros(size(im,1), size(im,2), size(D,1));

info = dicominfo( D(1).name );

f = waitbar(0, sprintf('Loading:  %u / %u', 0, size(D,1)));
for ind=1:size(D, 1)
    waitbar(ind/size(D,1), f, sprintf('Loading:  %u / %u', ind, size(D,1)));
    vol(:,:,ind) = dicomread( D(ind).name );
end
close(f);

cd ../../..
end