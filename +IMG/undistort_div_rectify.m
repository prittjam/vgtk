function [timg,trect,T,A] = undistort_div_rectify(img,K,proj_params,H,varargin)
    ru_xform = maketform('custom', 2, 2, ...
                @undistort_div_xform, ...
                @distort_div_xform, ...
                struct('K', K,...
                       'proj_params', proj_params,...
                       'rad_backproject_fn', @RAD.backproject_div));
    [timg,trect,T,A] = IMG.rectify(img, H, ...
                                   'ru_xform',ru_xform, ...
                                   'Registration', 'None', ...
                                   varargin{:});
end


function v = undistort_div_xform(u, T)
    v = CAM.undistort_div(u', T.tdata.K, T.tdata.proj_params)';
end

function v = distort_div_xform(u, T)
    v = CAM.distort_div(u', T.tdata.K, T.tdata.proj_params)';
end

