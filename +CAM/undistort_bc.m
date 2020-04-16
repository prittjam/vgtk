function xu = undistort_bc(xd, K, k)
    m = size(xd, 1);
    cameraParams = cameraParameters(...
                    'IntrinsicMatrix', K,...
                    'RadialDistortion', k(1:2),...
                    'TangentialDistortion', k(3:4));

    xu = undistortPoints(xd(1:2,:)', cameraParams)';
    if (m == 3)
        xu = [xu; ones(1,size(xu,2))];
    end
end