function [timg,trect,T,A] = undistort_div_rectify_KR(img,A,q,K,R,varargin)
    ru_xform = [];
    if q ~= 0
        ru_xform = make_undistort_div_xform(A, q);
    end
    R0 = [1 0 0 ; 0 -1 0; 0 0 -1];
    R = CAM.rotation_wrt_plane(R);
    H = K * R0 * R' * inv(K);
    [timg,trect,T,A] = IMG.rectify(img,H, ...
                                   'ru_xform',ru_xform, ...
                                   'Registration', 'None', ...
                                   varargin{:});
end

function T = make_undistort_div_xform(K, q)
    T = maketform('custom', 2, 2, ...
                @undistort_div_xform, ...
                @distort_div_xform, ...
                struct('K',K,'q',q));
end

function v = undistort_div_xform(u, T)
    v = CAM.undistort_div(u', T.tdata.K, T.tdata.q)';
end

function v = distort_div_xform(u, T)
    v = CAM.distort_div(u', T.tdata.K, T.tdata.q)';
end
