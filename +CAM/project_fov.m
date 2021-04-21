function v = project_fov(v, K, proj_params)
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

    R = vecnorm(v(1:2,:),2,1);
    r = atan2(2.*R.*tan(w/2),v(3,:))./w;
    v(1:2,r~=0) = v(1:2,r~=0).*r(r~=0)./R(r~=0);
    v(3,r~=0) = 1;

    if ~isempty(K)
        v = K * v;
    end
end