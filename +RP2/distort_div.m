function xd = distort_div(x, K, q)
    m = size(x, 1);
    xd = reshape(CAM.distort_div(reshape(x, 3, []), K, q), m, []);
end