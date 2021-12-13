function [edges] = edge_detection(mask)

for i = size(mask,3):-1:1
    edges(:,:,i) = edge(mask(:,:,i));
end

end