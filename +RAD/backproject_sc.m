function [ru, theta] = backproject_sc(rd, proj_params)
    a0 = proj_params(1);
    a = proj_params(2:end);
    pows = (2:numel(a)+1) .* (a~=0);
    w = (a0 + (rd'.^(pows)) * a')';
    ru = ones(size(rd)) * NaN;
    ind = find(w > 1e-8);
    ru(ind) = rd(ind) ./ w(ind);
    theta = atan2(rd,w);
end