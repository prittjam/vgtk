function xu = backproject_rat(xd, K, q, k)
    if nargin < 4
        k = 3;
    end
    m = size(xd, 1);
    xu = reshape(CAM.backproject_rat(reshape(xd, k, []), K, q), m, []);
end