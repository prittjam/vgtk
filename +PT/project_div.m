function xd = project_div(x, K, q, k)
    if nargin < 4
        k = 3;
    end
    m = size(x, 1);
    xd = reshape(CAM.project_div(reshape(x, k, []), K, q), m, []);
end