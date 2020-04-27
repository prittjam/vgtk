function cam = make_lens(cam, dist_params, A, dist_model);
    if nargin < 4 || isempty(dist_model)
        dist_model = 'div';
    end
    cam.q_norm = dist_params;
    cam.dist_model = dist_model;
    cam.A = A;
    unnorm_fun = str2func(['CAM.unnormalize_' dist_model]);
    cam.q = unnorm_fun(cam.q_norm, cam.A);
end