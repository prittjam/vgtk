function v = backproject_ds(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [xi, alpha] in mm
    %
    % Returns:
    %   v -- 3xN
    
    if ~isempty(K)
        v = K \ PT.renormI(v);
    end

    xi = proj_params(1);
    % alpha1 = xi/(xi+1);
    alpha = proj_params(2);

    r2 = sum(v(1:2,:).^2);
    Z2 = (1 - alpha^2*r2)./(alpha * sqrt(1 - (2*alpha-1).*r2) + 1 - alpha);
    v = (Z2*xi + sqrt(Z2.^2 + (1 - xi^2)*r2))./(r2+Z2.^2) .* ...
                                [v(1:2,:); Z2] - [0;0;xi];
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