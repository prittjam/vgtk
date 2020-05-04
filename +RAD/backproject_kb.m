function [ru, theta] = backproject_kb(rd, proj_params)
    k = proj_params;
    ru = ones(size(rd)) * NaN;
    for p=1:numel(rd)
        rts = roots([k(4) 0 k(3) 0 k(2) 0 k(1) 0 1 -rd(p)]);
        rts = real(rts(abs(imag(rts))<1e-8));
        rts = rts(rts >= 0);
        if numel(rts) == 0
            throw()
        else
            theta(p) = min(rts);
        end
    end
    ind = find(abs(abs(theta) - pi/2) > 1e-8);
    ru(ind) = tan(theta(ind));
end