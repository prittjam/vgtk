%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,trect,T,S] = distort_div(img,K,proj_params,varargin)
    T0 = maketform('custom', 2, 2, ...
                @distort_div_xform, ...
                @undistort_div_xform, ...
                struct('K', K,...
                       'proj_params', proj_params,...
                       'rad_backproject_fn', @RAD.project_div));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = undistort_div_xform(u, T)
    v = CAM.undistort_div(u', T.tdata.K, T.tdata.proj_params)';
end

function v = distort_div_xform(u, T)
    v = CAM.distort_div(u', T.tdata.K, T.tdata.proj_params)';
end