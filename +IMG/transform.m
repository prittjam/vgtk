function [timg,trect,T,S] = transform(img,T0,varargin)
    cfg = struct('border', [], 'size', size(img),...
                 'pure_xform', false, 'FillValues',255);
    cfg = cmp_argparse(cfg,varargin{:});

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

    if cfg.pure_xform
        S = eye(3);
        T = T0;
        timg = imtransform(img,T,'bicubic',...
                        'XYScale', 1, ...
                        'XData', [1 nx], ...
                        'YData', [1 ny], ...
                        'FillValues', cfg.FillValues);
        trect = [1 1 nx ny];
    else
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
                        'FillValues', cfg.FillValues);
        trect = [minx miny maxx maxy];
    end
end