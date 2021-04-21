function v = project_cmei(v, K, proj_params)
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

    R = vecnorm(v,2,1);
    v = v./R;

    % Z2 = xi*R + v(3,:);
    % v = [v(1:2,:)./Z2; ones(1,size(v,2))];

    % if xi>1, w = xi;
    % else, w = 1/xi;
    % end
    % valid = v(3,:) > -w * vecnorm(v);
    if xi > 0
        min_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi);
        valid = v(3,:) >= min_valid_Z;
    else
        % max_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi)
        % valid = v(3,:) <= max_valid_Z;
        % keyboard
        valid = ones(1,size(v,2));
    end

    Z2 = (xi + v(3,:))./(xi+1);
    v(:,valid) = [v(1:2,valid)./Z2(valid); ones(1,sum(valid))];
    v(:,~valid) = NaN;

    if ~isempty(K)
        v = K * v;
    end
end