function [timg,trect,T,S] = undistort_kb(img, K, proj_params, varargin);
    T0 = maketform('custom',2,2, ...
                @undistort_kb_xform, ...
                @distort_kb_xform, ...
                struct('K', K,...
                       'proj_params', proj_params,...
                       'rad_backproject_fn', @RAD.backproject_kb));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = undistort_kb_xform(u, T)
    v = CAM.undistort_kb(u', T.tdata.K, T.tdata.proj_params)';
end

function v = distort_kb_xform(u, T)
    v = CAM.distort_kb(u', T.tdata.K, T.tdata.proj_params)';
end
