function [x1, y1, x2, y2] = get_starting_points(mask)

x1 = fix(size(mask, 1)/2);
x2 = x1;
for j = 1:size(mask, 2)
    if mask(x1, j) == 1
        y1 = j;
        break
    end
end

for j = size(mask, 2):-1:1
    if mask(x2, j) == 1
        y2 = j;
        break
    end
end


end