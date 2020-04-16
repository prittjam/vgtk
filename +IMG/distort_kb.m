function [timg,trect,T,S] = distort_kb(img, K, dist_params, varargin);
    T0 = make_distort_kb_xform(K, dist_params);
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function T = make_distort_kb_xform(K, dist_params)
    T = maketform('custom', 2, 2, ...
                @distort_kb_xform, ...
                @undistort_kb_xform, ...
                struct('K',K,'dist_params',dist_params));
end

function v = undistort_kb_xform(u, T)
    v = CAM.undistort_kb(u', T.tdata.K, T.tdata.dist_params)';
end

function v = distort_kb_xform(u, T)
    v = CAM.distort_kb(u', T.tdata.K, T.tdata.dist_params)';
end
