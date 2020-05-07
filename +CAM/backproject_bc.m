function v = backproject_bc(u, K, proj_params)
    % proj_params -- [k1 k2 p1 p2]

    m = size(u, 1);
    if isempty(K)
        K = eye(3);
    end
    cameraParams = cameraParameters(...
                    'IntrinsicMatrix', K,...
                    'RadialDistortion', proj_params(1:2),...
                    'TangentialDistortion', proj_params(3:4));
    
    v = undistortPoints(u(1:2,end:-1:1)', cameraParams)';
    if (m == 3)
        v = [v; ones(1,size(v,2))];
    end
end