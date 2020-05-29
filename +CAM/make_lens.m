function cam = make_lens(cam, proj_params, A, proj_model);
    if nargin < 4 || isempty(proj_model) || strcmp(proj_model, 'div')
        proj_model = 'div';
        cam.q_norm = proj_params;
        cam.A = A;
        unnorm_fun = str2func(['CAM.unnormalize_' proj_model]);
        cam.q = unnorm_fun(cam.q_norm, cam.A);
    end

    cam.backproj_fn = ['backproject_' proj_model];
    cam.proj_fn = ['project_' proj_model];
    cam.proj_model = proj_model;
    cam.proj_params = proj_params;

    if ~isfield(cam, 'hov') && isfield(cam, 'nx') && isfield(cam, 'ny')
        [HFOV, VFOV, DFOV] = CAM.calc_FOV(cam.nx, cam.ny, cam.K, str2func(['RAD.' cam.backproj_fn]), cam.proj_params, 'units', 'rad');
        cam.hfov = HFOV;
        cam.vfov = VFOV;
        cam.dfov = DFOV;
    end
end