function xu = undistort_sc(xd, K, q, k)
    if nargin < 4
        k = 3;
    end
    m = size(xd, 1);
    xu = reshape(CAM.undistort_sc(reshape(xd, k, []), K, q), m, []);
end