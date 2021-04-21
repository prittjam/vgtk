function v = backproject_fov(v, K, proj_params)
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

    w = proj_params(1);
    r = sqrt(sum(v(1:2,:).^2));
    v = [v(1:2,:).*sin(r * w)./2./r./tan(w/2); cos(r * w)];
    v = v./vecnorm(v,2,1);
    
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