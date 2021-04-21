function v = backproject_bc(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [k1...kN t1...tN] in mm
    %
    % Returns:
    %   v -- 3xN

    if numel(proj_params)/2 < 4
        k = proj_params(1:numel(proj_params));
        t = zeros(1,numel(proj_params));
    else
        k = proj_params(1:numel(proj_params)/2);
        t = proj_params(numel(proj_params)/2+1:end);
    end

    if any(abs(proj_params)) > 0
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end

        rho = vecnorm(v(1:2,:),2,1);

        nonzero = find(rho~=0);
        for ii=nonzero
            coefs = reshape([k(end:-1:1); -rho(ii)*t(end:-1:1) ],1,[]);
            coefs = [coefs 1 -rho(ii)];
            rts2 = roots(coefs);
            rts2 = real(rts2(abs(imag(rts2))<1e-7));
            rts2 = rts2(rts2 > 0);
            if numel(rts2) < 1
                r(ii) = NaN;
            else    
                r(ii) = min(rts2);
            end
        end
        v(1:2,nonzero) = v(1:2,nonzero) .* r(:,nonzero) ./ rho(:,nonzero);
        v = v./vecnorm(v);

        if ~isempty(K)
            v = K * v;
        end
    end
end