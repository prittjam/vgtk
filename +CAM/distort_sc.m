function v = distort_sc(u, K, dist_params)
    % Args:
    %   u -- 3xN/2xN
    %   K -- 3x3
    %   dist_params -- [a0 a2 a3 a4 cx cy] in mm
    %
    % Returns:
    %   v -- 3xN/2xN
    
    m = size(u,1);
    if (m == 2)
        u = PT.homogenize(u);
    end
    v = CAM.project_sc(u, K, dist_params);
    if (m == 2)
        v = v(1:2,:);
    end
end
