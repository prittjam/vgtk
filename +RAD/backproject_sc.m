function [ru, theta] = backproject_sc(rd, a)
    a0 = a(1);
    a = a(2:end);
    pows = (2:numel(a)+1) .* (a~=0);
    w = (a0 + (rd'.^(pows)) * a')';
    ru = ones(size(rd)) * NaN;
    ind = find(w > 1e-8);
    ru(ind) = rd(ind) ./ w(ind);
    theta = atan2(rd,w);
end