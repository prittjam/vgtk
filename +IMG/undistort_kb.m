function [timg,trect,T,S] = undistort_kb(img, K, dist_params, varargin);
    T0 = maketform('custom',2,2, ...
                @undistort_kb_xform, ...
                @distort_kb_xform, ...
                struct('K',K,'dist_params',dist_params));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = undistort_kb_xform(u, T)
    v = CAM.undistort_kb(u', T.tdata.K, T.tdata.dist_params)';
end

function v = distort_kb_xform(u, T)
    v = CAM.distort_kb(u', T.tdata.K, T.tdata.dist_params)';
end
