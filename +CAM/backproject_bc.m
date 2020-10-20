function v = backproject_bc(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [k1 k2 p1 p2] in mm
    %
    % Returns:
    %   v -- 3xN

    if isempty(K)
        K = eye(3);
    end
    cameraParams = cameraParameters(...
                    'IntrinsicMatrix', K,...
                    'RadialDistortion', proj_params(1:2),...
                    'TangentialDistortion', proj_params(3:4));
    
    v = undistortPoints(v(1:2,end:-1:1)', cameraParams)';
    v = [v; ones(1,size(v,2))];
end