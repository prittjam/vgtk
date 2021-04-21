function [ru, theta, rd, w] = backproject_rat(rd, proj_params)
    lambda = proj_params;
    mu = zeros(size(lambda));
    pows = 2:2:2*size(lambda,2);
    w = (1 + lambda * rd.^(pows')) ./ (1 + mu * rd.^(pows'));
    ru = ones(size(rd)) * NaN;
    ind = find(w > 1e-8);
    ru(ind) = rd(ind) ./ w(ind);
    theta = atan2(rd,w);
end