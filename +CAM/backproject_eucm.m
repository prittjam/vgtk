function v = backproject_eucm(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [xi] in mm
    %
    % Returns:
    %   v -- 3xN
    
    if ~isempty(K)
        v = K \ PT.renormI(v);
    end

    % xi = proj_params(1);
    % alpha = xi/(xi+1);
    alpha = proj_params(1);
    xi = 1/(1-alpha)-1;
    beta = proj_params(2);

    min_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi);
    max_valid_r = (xi + 1) * sqrt(1-min_valid_Z^2)./(xi + min_valid_Z);
    valid = vecnorm(v(1:2,:)) < max_valid_r;

    r2 = sum(v(1:2,:).^2);
    v(3,:) = (1 - beta * alpha^2 .* r2)./(alpha * sqrt(1 - (2*alpha-1)*beta.*r2)+(1-alpha));
    v = v./vecnorm(v);
    
    if ~isempty(K)
        keyboard
        ru = ones(size(r)) * NaN;
        valid_ind = theta < (pi/2 - 1e-5);
        ru(valid_ind) = tan(theta(valid_ind));
        v(1:2,ind) = v(1:2,ind) .* ru(ind);
        v(3,ind) = 1;
        v(:,ind) = K * v(:,ind);
        v(:,~ind) = NaN;
    end
end