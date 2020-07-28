function v = undistort_div(u, K, proj_params)
    % TODO: disambiguate functions
    v = CAM.backproject_div(u, K, proj_params);
end