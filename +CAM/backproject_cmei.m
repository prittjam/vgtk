function v = backproject_cmei(v, K, proj_params)
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

    xi = proj_params(1);
    alpha = xi/(xi+1);

    min_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi);
    max_valid_r = (xi + 1) * sqrt(1-min_valid_Z^2)./(xi + min_valid_Z);
    valid = vecnorm(v(1:2,:)) < max_valid_r;

    v(1:2,:) = v(1:2,:) ./ (xi + 1);
    r2 = sum(v(1:2,:).^2);
    v(3,:) = (sqrt(1 + (1 - xi^2)*r2) - xi*r2)./(r2+1);
    v(1:2,:) = v(1:2,:) .* (v(3,:) + xi);
    % v = (xi + sqrt(1 + (1 - xi^2) * r2))./(r2+1) .* [v(1:2,:);ones(1,size(v,2))] - [0;0;xi];

    % v(:,~valid) = NaN;

    
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