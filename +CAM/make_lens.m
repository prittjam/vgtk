function cam = make_lens(cam, proj_params, proj_model);
    cam.proj_model = proj_model;
    cam.proj_params = proj_params;

    rad_backproj_fn = str2func(['RAD.backproject_' cam.proj_model]);
    assert(isfield(cam, 'nx') && isfield(cam, 'ny'))
    [cam.hfov, cam.vfov, cam.dfov] = ...
            CAM.calc_FOV(cam.nx, cam.ny, cam.K,...
            rad_backproj_fn, cam.proj_params,...
            'units', 'rad');
end