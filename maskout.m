function masked = maskout(src,mask)
    % mask: binary, same size as src, but does not have to be same data type (int vs logical)
    % src: rgb or gray image
    masked = bsxfun(@times, src, cast(mask,class(src)));
end