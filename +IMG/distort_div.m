function [timg,trect,T,S] = distort_div(img, K, q, varargin)
    T0 = make_distort_div_xform(K, q);
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end


function T = make_distort_div_xform(K, q)
    T = maketform('custom', 2, 2, ...
                @distort_div_xform, ...
                @undistort_div_xform, ...
                struct('K', K, 'q', q));
end

function v = undistort_div_xform(u, T)
    v = CAM.undistort_div(u', T.tdata.K, T.tdata.q)';
end

function v = distort_div_xform(u, T)
    v = CAM.distort_div(u', T.tdata.K, T.tdata.q)';
end
