function [x, x_norm] = rgn(n, wplane, hplane, cam)
    X = PLANE.make_cspond_set_t(n, wplane, hplane);
    x = CAM.image_planar_pts(X, cam);
    x_norm = RP2.normalize(x, cam.K);
end