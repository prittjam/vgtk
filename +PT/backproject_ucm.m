function xu = backproject_ucm(xd, K, q, k)
    if nargin < 4
        k = 3;
    end
    m = size(xd, 1);
    xu = reshape(CAM.backproject_ucm(reshape(xd, k, []), K, q), m, []);
end