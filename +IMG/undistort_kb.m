function [timg,trect,T,S] = undistort_kb(img, K, proj_params, varargin);
    T0 = maketform('custom',2,2, ...
                @backproject_kb_xform, ...
                @project_kb_xform, ...
                struct('K', K,...
                       'proj_params', proj_params,...
                       'rad_backproject_fn', @RAD.backproject_kb));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = backproject_kb_xform(u, T)
    v = CAM.backproject_kb(u', T.tdata.K, T.tdata.proj_params)';
end

function v = project_kb_xform(u, T)
    v = CAM.project_kb(u', T.tdata.K, T.tdata.proj_params)';
end
