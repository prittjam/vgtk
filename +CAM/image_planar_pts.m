function [xd, x, xd_norm] = image_planar_pts(X, cam)
    % Images coplanar points with division model of radial distortion 
    % Args:
    %   X -- planar points in RP2
    %   cam -- camera struct
    % Returns:
    %   xd -- image points in RP2

    if ~isfield(cam, 'proj_model')
        x = RP2.renormI(RP2.multiprod(cam.P, X));
        xd = RP2.distort_div(x, cam.K, cam.q_norm);
        xd_norm = RP2.normalize(xd, cam.K);
    else
        project_x = str2func(['RP2.' cam.proj_fn]);
        x = RP2.mtimesx(cam.P, X);
        xd = project_x(x, cam.K, cam.proj_params);
        xd_norm = RP2.normalize(xd, cam.K);
        x = RP2.renormI(x);
    end
end