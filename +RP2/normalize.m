function x = normalize(x, K)
    if size(x,1)==2
        x = [x; ones(1,size(x,2))];
    end
    x = PT.normalize(x, K, 3);
end