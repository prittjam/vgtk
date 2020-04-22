function img  = draw_raster(img,x,y,varargin)
    cfg = struct;
    cfg.xsize = 20;
    [cfg, leftover] = cmp_argparse(cfg, varargin{:});
    a = cfg.xsize;
    img = LINE.draw_raster(img, max(x-a,0), max(y-a,0),...
                                min(x+a,size(img,2)),...
                                min(y+a,size(img,1)),...
                                leftover{:});
    img = LINE.draw_raster(img, max(x-a,0), min(y+a,size(img,1)),...
                                min(x+a,size(img,2)), max(y-a,0),...
                                leftover{:});
end