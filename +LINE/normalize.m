function l = normalize(l, K)
    % l -- line in the image (hom.) coordinates
    % K -- camera matrix
    
    l = K' * l;
end