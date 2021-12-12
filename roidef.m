%% ROI segmentation
function [lungs, fileNames1] = roidef(fileNames, stack, sizeI)
fileNames1=fileNames;
    for i=length(fileNames):-1:1
        lim_in=stretchlim(stack(:,:,i));
        contr(:,:,i)=imadjust(stack(:,:,i),[lim_in(1) (lim_in(2))],[0 1]);

        b(:,:,i)=imbinarize(contr(:,:,i));

        se=strel('disk',10,8);
        c(:,:,i)=imerode(b(:,:,i),se);

        [Out(:,:,i), rp] = getLargestCc(c(:,:,i));

        Out_compl(:,:,i) = imcomplement(Out(:,:,i));

        mask(:,:,i) = imclearborder(Out_compl(:,:,i));

        lungs(:,:,i) = maskout(stack(:,:,i), mask(:,:,i));

        if ((sum(sum(lungs(:,:,i)==0)))>0.98*(sizeI(1)*sizeI(1)))
            fileNames1{i} = 0;
        end
    end
    count = 0;
    acc = zeros(1,length(fileNames));
    for i=1:1:length(fileNames)-1
        if fileNames1{i}~=0
            count=count+1;
            acc(i)=count;
            if fileNames1{i+1}==0
                acc(i)=count;
                count=0;
            end
        end
    end
    [x, pos]=max(acc);
    
    if x<0.1*length(fileNames)
        fileNames1=fileNames;
        fprintf('sono meno del 10 ripeto')
        for i=length(fileNames):-1:1
            lim_in=stretchlim(stack(:,:,i));
            contr(:,:,i)=imadjust(stack(:,:,i),[lim_in(1) (lim_in(2))],[0 1]);

            b(:,:,i)=imbinarize(contr(:,:,i));

            se=strel('disk',8,8);
            c(:,:,i)=imerode(b(:,:,i),se);

            [Out(:,:,i), rp] = getLargestCc(c(:,:,i));

            Out_compl(:,:,i) = imcomplement(Out(:,:,i));

            mask(:,:,i) = imclearborder(Out_compl(:,:,i));

            lungs(:,:,i) = maskout(stack(:,:,i), mask(:,:,i));

            if ((sum(sum(lungs(:,:,i)==0)))>0.99*(sizeI(1)*sizeI(1)))
                fileNames1{i} = 0;
            end
        end
    count = 0;
    acc = zeros(1,length(fileNames));
    for i=1:1:length(fileNames)-1
        if fileNames1{i}~=0
            count=count+1;
            acc(i) = count;
            if fileNames1{i+1}==0
                acc(i)=count;
                count=0;
            end
        end
    end
    [x, pos]=max(acc);
    end
    for i=length(fileNames):-1:1
        if i<=pos-x || i>=pos+1   
           fileNames1{i} = 0; 
           lungs(:,:,i)=[];
        end
    end
end 