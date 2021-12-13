% roidef returns a mask with lungs position given a CT stack
% Inputs:
% -------
%   stack - input 3-D array of the CT scan
%   view - "axial" or "coronal"
%
% Outputs:
% --------
%   mask - 3-D array of the same dimensions of stack with pixel = true
%   where lungs have been detected

function mask = roidef(stack, view, noise_density)

    if strcmp(view, 'axial')
        for i=size(stack,3):-1:1
            
            if (0 <= noise_density) && (noise_density <= 0.05)
                stack(:,:,i) = medfilt2(stack(:,:,i), [3 3]);
            elseif (0.05 < noise_density) && (noise_density <= 0.2)
                stack(:,:,i) = medfilt2(stack(:,:,i), [4 4]);
            elseif noise_density > 0.2
                stack(:,:,i) = medfilt2(stack(:,:,i), [5 5]);
            end
            % contrast adjustments
            lim_in=stretchlim(stack(:,:,i));
            contr(:,:,i)=imadjust(stack(:,:,i),[lim_in(1) (lim_in(2))],[0 1]);
            
            % image to logic values
            b(:,:,i)=imbinarize(contr(:,:,i));
            
            % elements inside lungs removal
            se=strel('disk',4,4);
            c(:,:,i)=imerode(b(:,:,i),se);
            
            % extraction of largest component of the current slice
            [Out(:,:,i), ~] = getLargestCc(c(:,:,i));
            
            % complementary of the image: lungs have pixel = 1
            Out_compl(:,:,i) = imcomplement(Out(:,:,i));
            
            % filling background with the same value of the body
            mask(:,:,i) = imclearborder(Out_compl(:,:,i));
    
        end
    elseif strcmp(view, 'coronal')
        % permuting the stack in order to have coronal view in the third
        % dimension
        stack = permute(stack, [3 2 1]);

        for i=size(stack,3):-1:1

            if (0 <= noise_density) && (noise_density <= 0.05)
                stack(:,:,i) = medfilt2(stack(:,:,i), [3 3]);
            elseif (0.05 < noise_density) && (noise_density <= 0.2)
                stack(:,:,i) = medfilt2(stack(:,:,i), [4 4]);
            elseif noise_density > 0.2
                stack(:,:,i) = medfilt2(stack(:,:,i), [5 5]);
            end

            lim_in=stretchlim(stack(:,:,i));
            contr(:,:,i)=imadjust(stack(:,:,i),[lim_in(1) (lim_in(2))],[0 1], 0.5);
    
            b(:,:,i)=imbinarize(contr(:,:,i));
    
            se=strel('disk',3, 4);
            c(:,:,i)=imerode(b(:,:,i),se);
            
            [Out(:,:,i), ~] = getLargestCc(c(:,:,i));
    
            Out_compl(:,:,i) = imcomplement(Out(:,:,i));
            
            % using fill_area instead of imclearborder for more flexibility
            [mask(:,:,i), ~] = fill_area(Out_compl(:,:,i), 1, 1, 1, 0, 0, 0, 0);
            [mask(:,:,i), ~] = fill_area(mask(:,:,i), 1, size(Out_compl(:,:,i), 2), 1, 0, 0, 0, 0);
    
        end
    else
        error('You have to select either "axial" or "coronal"');
    end
end