function v = project_eucm(v, K, proj_params)
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

    R = vecnorm(v,2,1);
    v = v./R;
    
    if xi > 0
        min_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi);
        valid = v(3,:) >= min_valid_Z;
    else
        valid = ones(1,size(v,2));
    end

    d = sqrt(beta*(v(1,:).^2 + v(2,:).^2) + v(3,:).^2);

    Z2 = alpha*d + (1-alpha)*v(3,:);
    v(:,valid) = [v(1:2,valid)./Z2(valid); ones(1,sum(valid))];
    v(:,~valid) = NaN;

    if ~isempty(K)
        v = K * v;
    end
end