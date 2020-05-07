function [timg,trect,T,S] = undistort_sc(img, K, dist_params, varargin);
    T0 = maketform('custom',2,2, ...
                @undistort_sc_xform, ...
                @distort_sc_xform, ...
                struct('K',K,...
                       'dist_params',dist_params));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = undistort_sc_xform(u, T)
    v = CAM.undistort_sc(u', T.tdata.K, T.tdata.dist_params)';
end

function v = distort_sc_xform(u, T)
    v = CAM.distort_sc(u', T.tdata.K, T.tdata.dist_params)';
end
