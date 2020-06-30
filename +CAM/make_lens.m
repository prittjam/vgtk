function cam = make_lens(cam, proj_params, proj_model);
    cam.backproj_fn = ['backproject_' proj_model];
    cam.proj_fn = ['project_' proj_model];
    cam.proj_model = proj_model;
    cam.proj_params = proj_params;

    if ~isfield(cam, 'hfov') && isfield(cam, 'nx') && isfield(cam, 'ny')
        [HFOV, VFOV, DFOV] = CAM.calc_FOV(cam.nx, cam.ny, cam.K, str2func(['RAD.' cam.backproj_fn]), cam.proj_params, 'units', 'rad');
        cam.hfov = HFOV;
        cam.vfov = VFOV;
        cam.dfov = DFOV;
    end
end