%% ROI segmentation
function [lungs, mask] = roidef(stack)
    for i=size(stack,3):-1:1
        lim_in=stretchlim(stack(:,:,i));
        contr(:,:,i)=imadjust(stack(:,:,i),[lim_in(1) (lim_in(2))],[0 1]);

        b(:,:,i)=imbinarize(contr(:,:,i));

        se=strel('disk',4,4);
        c(:,:,i)=imerode(b(:,:,i),se);

        [Out(:,:,i), ~] = getLargestCc(c(:,:,i));

        Out_compl(:,:,i) = imcomplement(Out(:,:,i));

        mask(:,:,i) = imclearborder(Out_compl(:,:,i));

        lungs(:,:,i) = maskout(stack(:,:,i), mask(:,:,i));

        lim_in = stretchlim(lungs(:,:,i));
        lungs(:,:,i) = imadjust(lungs(:,:,i), [lim_in(1) (lim_in(2))],[0 1], 0.8);

    end