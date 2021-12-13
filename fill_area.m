% fill_are returns an image with the area connected to the starting point
% filled with a new value
%
% Inputs:
% -------
%   img_in - input 2-D array to be filled
%   x - x-coordinate of the starting position
%   y - y-coordinate of the starting position
%   val - tha value of the pixels to be filled
%   toll_low - lower tolerance
%   toll_high - upper tolerance
%   new_val - value to fill the area with
%   area - parameter needed for recursion, put 0 when calling the function
%
% Outputs:
% --------
%   img_out - 2-D array of the filled image
%   area - the dimension in pixels of the filled area

function [img_out, area] = fill_area(img_in, x, y, val, toll_low, toll_high, new_val, area)
    img_out = img_in;
    if val - toll_low <= img_out(x,y) && img_out(x,y) <= val + toll_high
        img_out(x,y) = new_val;
        area = area +1;
        if x > 1
            img_out = fill_area(img_out, x-1, y, val, toll_low, toll_high, new_val, area);
        end
        if x < size(img_out, 1)
            img_out = fill_area(img_out, x+1, y, val, toll_low, toll_high, new_val, area);
        end
        if y > 1
            img_out = fill_area(img_out, x, y-1, val, toll_low, toll_high, new_val, area);
        end
        if y < size(img_out, 2)
            img_out = fill_area(img_out, x, y+1, val, toll_low, toll_high, new_val, area);
        end
    else
        return
    end

end