function [xd, x] = image_planar_pts(X, cam)
    % Images coplanar points with division model of radial distortion 
    % Args:
    %   X -- planar points in RP2
    %   cam -- camera struct
    % Returns:
    %   xd -- image points in RP2

    x = RP2.renormI(RP2.multiprod(cam.P, X));
    if ~isfield(cam, 'dist_model')
        cam.dist_model = 'div';
    end
    distort_fun = str2func(['RP2.distort_' cam.dist_model]);
    xd = distort_fun(x, cam.A, cam.q_norm);
end