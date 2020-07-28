function [ru, theta] = backproject_div(rd, proj_params)
    q = proj_params(1);
    w = 1 + q * rd.^2;
    ru = ones(size(rd)) * NaN;
    ind = find(w > 1e-8);
    ru(ind) = rd(ind) ./ w(ind);
    theta = atan2(rd,w);
end