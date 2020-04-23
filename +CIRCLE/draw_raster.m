function img  = draw_raster(img,x,y,r,varargin)
    cfg = struct;
    cfg.linewidth = 5;
    cfg.channel = 1;
    cfg = cmp_argparse(cfg, varargin{:});

    clr = [0 0 0];
    clr(cfg.channel) = 255;
    if ndims(img)==2
        img = repmat(img,1,1,3);
    end
    img = insertShape(img, 'circle', [x, y, r],...
                      'LineWidth', cfg.linewidth, 'Color', clr);
end