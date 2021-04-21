function v = project_ds(v, K, proj_params)
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
    xi2 = alpha/(1-alpha);

    R = vecnorm(v,2,1);
    v = v./R;

    % if xi > 0
    %     min_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi);
    %     valid = v(3,:) >= min_valid_Z;
    % else
        valid = ones(1,size(v,2));
    % end
    % if alpha <= 0.5
    %     w1 = alpha / (1 - alpha);
    % else
    %     w1 = (1 - alpha) / alpha;
    % end
    % w2 = w1 + xi / sqrt(2 * w1 * xi + xi^2 + 1);
    % valid = v(3,:) >= -w2;

    Z2 = xi + v(3,:);
    % Z2 = (xi + v(3,:))./(xi+1);
    R2 = sqrt(sum(v(1:2,:).^2) + Z2.^2);
    Z3 = (xi2*R2 + Z2)./(xi2+1);
    v = [v(1:2,:)./Z3; ones(1,size(v,2))];
    v(:,~valid) = NaN;

    if ~isempty(K)
        v = K * v;
    end
end