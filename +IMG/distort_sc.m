function [timg,trect,T,S] = distort_sc(img, K, proj_params, varargin);
    T0 = maketform('custom', 2, 2, ...
                @project_sc_xform, ...
                @backproject_sc_xform, ...
                struct('K', K,...
                       'proj_params', proj_params,...
                       'rad_backproject_fn', @RAD.backproject_sc));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = backproject_sc_xform(u, T)
    v = CAM.backproject_sc(u', T.tdata.K, T.tdata.proj_params)';
end

function v = project_sc_xform(u, T)
    v = CAM.project_sc(u', T.tdata.K, T.tdata.proj_params)';
end