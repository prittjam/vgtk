%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,trect,T,S] = undistort_div(img,K,q,varargin)
    T0 = maketform('custom', 2, 2, ...
                @undistort_div_xform, ...
                @distort_div_xform, ...
                struct('K',K,'q',q));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = undistort_div_xform(u, T)
    v = CAM.undistort_div(u', T.tdata.K, T.tdata.q)';
end

function v = distort_div_xform(u, T)
    v = CAM.distort_div(u', T.tdata.K, T.tdata.q)';
end
