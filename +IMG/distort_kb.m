function [timg,trect,T,S] = project_kb(img, K, dist_params, varargin);
    T0 = make_project_kb_xform(K, dist_params);
    [timg,trect,T,S] = IMG.transform(img,T0,varargin{:});
end

function T = make_project_kb_xform(K, dist_params)
    T = maketform('custom', 2, 2, ...
                @project_kb_xform, ...
                @backproject_kb_xform, ...
                struct('K',K,'dist_params',dist_params));
end

function v = backproject_kb_xform(u, T)
    v = CAM.backproject_kb(u', T.tdata.K, T.tdata.dist_params)';
end

function v = project_kb_xform(u, T)
    v = CAM.project_kb(u', T.tdata.K, T.tdata.dist_params)';
end
