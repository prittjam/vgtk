function [x, x_norm] = ms_ct(n, ct_type, dist_model, dist_params)
    if nargin < 2 || isempty(ct_type)
        ct_type = 'rgn';
    end
    if nargin < 3 || isempty(dist_model)
        dist_model = 'div';
        dist_params = -4;
    end

    nx = 1000;
    ny = 1000;

    wplane = 10;
    hplane = 10;

    
    f_mm = 5*rand(1)+3;
    ccd_mm = 4.8;
    cam = CAM.make_ccd(f_mm, ccd_mm, nx, ny);
    cam = CAM.make_lens(cam, dist_params, cam.K, dist_model);
    cam = CAM.make_viewpoint(cam);

    X = PLANE.make_cspond_set_t(n, wplane, hplane);
    if strcmp(ct_type, 'pt')
        X = X(1:6,:);
    end
    x = CAM.image_planar_pts(X, cam);
    x_norm = RP2.normalize(x, cam.K);
end