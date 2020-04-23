function img  = draw_raster(img,x,y,varargin)
    cfg = struct;
    cfg.xsize = 20;
    cfg.kind = 'circ';
    cfg.goal = false;
    [cfg, leftover] = cmp_argparse(cfg, varargin{:});
    a = cfg.xsize;
    if strcmp(cfg.kind, 'cross')
        a = a * sqrt(2) / 2;
        img = LINE.draw_raster(img, max(x-a,0), max(y-a,0),...
                                    min(x+a,size(img,2)),...
                                    min(y+a,size(img,1)),...
                                    leftover{:});
        img = LINE.draw_raster(img, max(x-a,0), min(y+a,size(img,1)),...
                                    min(x+a,size(img,2)), max(y-a,0),...
                                    leftover{:});
    elseif strcmp(cfg.kind, 'circ')
        img = CIRCLE.draw_raster(img,x,y,a,leftover{:});
    else
        throw();
    end
    if cfg.goal
        cfg2.channel = 1;
        [cfg2,~] = cmp_argparse(cfg2, leftover{:});
        img = LINE.draw_raster(img, 1,y, size(img,2), y,...
                               'linewidth', 3,...
                               'channel', cfg2.channel);
        img = LINE.draw_raster(img, x,1, x, size(img,1),...
                               'linewidth', 3,...
                               'channel', cfg2.channel);
    end
end