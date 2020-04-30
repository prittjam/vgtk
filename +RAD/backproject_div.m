function [ru, theta] = backproject_div(rd, q)
    w = 1 + q * rd.^2;
    ru = ones(size(rd)) * NaN;
    ind = find(w > 1e-8);
    ru(ind) = rd ./ w;
    theta = atan2(rd,w);
end