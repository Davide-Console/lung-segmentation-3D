function [img_out, volume] = fill_area(img_in, x, y, z, val, toll_low, toll_high, new_val, volume)
    img_out = img_in;
    if val - toll_low <= img_out(x,y,z) && img_out(x,y,z) <= val + toll_high
        img_out(x,y,z) = new_val;
        volume = volume +1;
        if x > 1
            img_out = fill_area(img_out, x-1, y, z, val, toll_low, toll_high, new_val, volume);
        end
        if x < size(img_out, 1)
            img_out = fill_area(img_out, x+1, y, z, val, toll_low, toll_high, new_val, volume);
        end
        if y > 1
            img_out = fill_area(img_out, x, y-1, z, val, toll_low, toll_high, new_val, volume);
        end
        if y < size(img_out, 2)
            img_out = fill_area(img_out, x, y+1, z, val, toll_low, toll_high, new_val, volume);
        end
        if z > 1
            img_out = fill_area(img_out, x, y, z-1, val, toll_low, toll_high, new_val, volume);
        end
        if z < size(img_out, 3)
            img_out = fill_area(img_out, x, y, z+1, val, toll_low, toll_high, new_val, volume);
        end
    else
        return
    end

end