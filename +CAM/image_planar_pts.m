function [xd, x] = image_planar_pts(X, cam)
    % Images coplanar points with division model of radial distortion 
    % Args:
    %   X -- planar points in RP2
    %   cam -- camera struct
    % Returns:
    %   xd -- image points in RP2

    x = RP2.renormI(RP2.multiprod(cam.P, X));
    xd = RP2.distort_div(x, cam.A, cam.q_norm);
end