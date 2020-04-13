function [timg,trect,T,S] = undistort_kb(img, K, dist_coeffs, varargin);
    cfg = struct('border', [], 'size', size(img));
    cfg = cmp_argparse(cfg, varargin{:});
    T0 = make_undistort_kb_xform(K, dist_coeffs);
    nx = size(img,2);
    ny = size(img,1);
    if ~isempty(cfg.border)
        border = cfg.border;
    else
        border = [1  1; ...
                nx 1; ...    
                nx ny; ...
                1  ny];
    end
    [T,S] = IMG.register_by_size(T0,border,cfg.size, ...
                                'LockAspectRatio', false);
    tbounds = tformfwd(T,border);

    minx = min(tbounds(:,1));
    maxx = max(tbounds(:,1));
    miny = min(tbounds(:,2));
    maxy = max(tbounds(:,2));

    timg = imtransform(img,T,'bicubic', ...
                        'XYScale',1, ...
                        'XData',[minx maxx], ...
                        'YData',[miny maxy], ...
                        'Fill',transpose([255 255 255]));

    trect = [minx miny maxx maxy];
end

function T = make_undistort_kb_xform(K, dist_coeffs)
    T = maketform('custom',2,2, ...
                @undistort_kb_xform, ...
                @distort_kb_xform, ...
                struct('K',K,'dist_coeffs',dist_coeffs));
end

function v = undistort_kb_xform(u, T)
    v = CAM.undistort_kb(u', T.tdata.K, T.tdata.dist_coeffs)';
end

function v = distort_kb_xform(u, T)
    v = CAM.distort_kb(u', T.tdata.K, T.tdata.dist_coeffs)';
end
