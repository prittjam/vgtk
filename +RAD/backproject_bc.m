function [ru, theta] = backproject_bc(rd, proj_params)
    k = proj_params;
    for p=1:numel(rd)
        rts = roots([k(2) 0 k(1) 0 1 -rd(p)]);
        rts = real(rts(abs(imag(rts))<1e-8));
        rts = rts(rts >= 0);
        if numel(rts) == 0
            ru(p) = NaN;
            theta(p) = NaN;
        else
            ru(p) = min(rts);
            theta(p) = atan(ru(p));
        end
    end
end