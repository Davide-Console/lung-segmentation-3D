function img_out = fill_area(img_in, x, y, val, toll_low, toll_high, new_val)
    img_out = img_in;
    if val - toll_low <= img_out(x,y) && img_out(x, y) <= val + toll_high
        img_out(x,y) = new_val;
        if x > 1
            img_out = fill_area(img_out, x-1, y, val, toll_low, toll_high, new_val);
        end
        if x < size(img_out, 1)
            img_out = fill_area(img_out, x+1, y, val, toll_low, toll_high, new_val);
        end
        if y > 1
            img_out = fill_area(img_out, x, y-1, val, toll_low, toll_high, new_val);
        end
        if y < size(img_out, 2)
            img_out = fill_area(img_out, x, y+1, val, toll_low, toll_high, new_val);
        end

    else
        return
    end

end