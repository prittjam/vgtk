function [timg,trect,T,S] = backproject_kb(img, K, dist_params, varargin);
    T0 = maketform('custom',2,2, ...
                @backproject_kb_xform, ...
                @project_kb_xform, ...
                struct('K',K,'dist_params',dist_params));
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function v = backproject_kb_xform(u, T)
    v = CAM.backproject_kb(u', T.tdata.K, T.tdata.dist_params)';
end

function v = project_kb_xform(u, T)
    v = CAM.project_kb(u', T.tdata.K, T.tdata.dist_params)';
end
