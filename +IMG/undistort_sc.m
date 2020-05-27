function [timg,trect,T,S] = undistort_sc(img, K, dist_params, varargin);
    T0 = maketform('custom',2,2, ...
                @backproject_sc_xform, ...
                @project_sc_xform, ...
                struct('K',K,...
                       'dist_params',dist_params));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = backproject_sc_xform(u, T)
    v = CAM.backproject_sc(u', T.tdata.K, T.tdata.dist_params)';
end

function v = project_sc_xform(u, T)
    v = CAM.project_sc(u', T.tdata.K, T.tdata.dist_params)';
end