function v = project_rat(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [mu1...muk lambda1...lambdak] in mm
    %
    % Returns:
    %   v -- 3xN

    % mu = proj_params(1:numel(proj_params)/2);
    % lambda = proj_params(numel(proj_params)/2+1:end);
    lambda = proj_params;
    mu = zeros(size(lambda));

    if any(abs(proj_params)) > 0
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end

        R = vecnorm(v(1:2,:),2,1);
        Z = v(3,:);

        nonzero = find(R~=0);

        for k=nonzero
            coefs = reshape([zeros(size(lambda)); lambda(end:-1:1)],1,[]);
            coefs = [coefs -Z(k)/R(k) 1];
            rts2 = roots(coefs);
            rts2 = real(rts2(abs(imag(rts2))<1e-7));
            rts2 = rts2(rts2 > 0);
            if numel(rts2) < 1
                r(k) = NaN;
            else    
                r(k) = min(rts2);
            end
        end
        v(1:2,nonzero) = v(1:2,nonzero) .* r(:,nonzero) ./ R(:,nonzero);
        v(3,:) = 1;

        if ~isempty(K)
            v = K * v;
        end
    end
end