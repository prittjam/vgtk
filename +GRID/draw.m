function draw(xgrid, varargin)
    cfg.size = 25;
    cfg.color = [];
    [cfg, leftover] = cmp_argparse(cfg, varargin{:});
    
    marker_params = {'Marker','.','MarkerSize',cfg.size};

    color_flag = isvector(cfg.color) & isnumeric(cfg.color) & ~all(cfg.color<=1 & cfg.color>=0);
    if color_flag
        N = max(cfg.color);
    else
        N = size(xgrid,2);
    end
    colormap(hsv(N))
    cmap = colormap;
    
    if size(xgrid,1) > 2
        xgrid = PT.renormI(xgrid);
        for k=1:size(xgrid,2)
            hold on
            if color_flag
                plot(xgrid(1:3:end,k), xgrid(2:3:end,k), marker_params{:},"Color", cmap(cfg.color(k),:), leftover{:});
            elseif isempty(cfg.color)
                plot(xgrid(1:3:end,k), xgrid(2:3:end,k), marker_params{:},"Color", cmap(k,:), leftover{:});
            else
                plot(xgrid(1:3:end,k), xgrid(2:3:end,k), marker_params{:},"Color",cfg.color,leftover{:});
            end
        end
    end
    colormap(gray)
end