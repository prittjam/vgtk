function v = undistort_kb(u, K, dist_params)
    % Args:
    %   u -- 3xN/2xN
    %   K -- 3x3
    %   dist_params -- 
    %
    % Returns:
    %   v -- 3xN/2xN

    m = size(u,1);
    if (m == 2)
        u = PT.homogenize(u);
    end
    v = CAM.backproject_kb(u, K, dist_params);
    if (m == 2)
        v = v(1:2,:);
    end
end
