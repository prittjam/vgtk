function [timg,trect,T,S] = distort_sc(img, K, dist_params, varargin);
    T0 = maketform('custom', 2, 2, ...
                @distort_sc_xform, ...
                @undistort_sc_xform, ...
                struct('K',K,...
                       'MappingCoefficients',dist_params{1},...
                       'DistortionCenter',dist_params{2},...
                       'Stretchmatrix',dist_params{3},...
                       'ImageSize',dist_params{4}));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = undistort_sc_xform(u, T)
    dist_params = {T.tdata.MappingCoefficients,...
                   T.tdata.DistortionCenter,...
                   T.tdata.Stretchmatrix,...
                   T.tdata.ImageSize};
    v = CAM.undistort_sc(u', T.tdata.K, dist_params)';
end

function v = distort_sc_xform(u, T)
    dist_params = {T.tdata.MappingCoefficients,...
                   T.tdata.DistortionCenter,...
                   T.tdata.Stretchmatrix,...
                   T.tdata.ImageSize};
    v = CAM.distort_sc(u', T.tdata.K, dist_params)';
end