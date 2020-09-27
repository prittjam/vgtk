function draw3d(xgrid, varargin)
    cfg.size = 25;
    cfg.color = [];
    cfg.text = [];
    cfg.ts = [5 5];
    [cfg, leftover] = cmp_argparse(cfg, varargin{:});
    ts = cfg.ts;

    marker_params = {'Marker','.','MarkerSize',cfg.size};

    color_flag = isvector(cfg.color) & isnumeric(cfg.color) & all(mod(cfg.color,1)==0) & ~all(cfg.color<=1 & cfg.color>=0);
    color_flag = all(color_flag);
    if color_flag
        N = max(cfg.color);
    else
        N = size(xgrid,2);
    end
    colormap(hsv(N))
    cmap = colormap;
    
    if rem(size(xgrid,1),4)~=0
        xgrid = RP3.homogenize(xgrid);
    end
    if size(xgrid,1) > 3
        xgrid = PT.renormI(xgrid,4);
        for k=1:size(xgrid,2)
            hold on
            if color_flag
                plot3(xgrid(1:4:end,k), xgrid(2:4:end,k), xgrid(3:4:end,k), marker_params{:},"Color", cmap(cfg.color(k),:), leftover{:});
                if ~isempty(cfg.text)
                    text(xgrid(1,k)+ts(1), xgrid(2,k)+ts(2), xgrid(3,k)+ts(3), cfg.text{k}, "Color", cmap(cfg.color(k),:));
                end
            elseif isempty(cfg.color)
                plot3(xgrid(1:4:end,k), xgrid(2:4:end,k), xgrid(3:4:end,k), marker_params{:},"Color", cmap(k,:), leftover{:});
                if ~isempty(cfg.text)
                    text(xgrid(1,k)+ts(1), xgrid(2,k)+ts(2), xgrid(3,k)+ts(3), cfg.text{k}, "Color", cmap(k,:));
                end
            else
                plot3(xgrid(1:4:end,k), xgrid(2:4:end,k), xgrid(3:4:end,k), marker_params{:},"Color",cfg.color(:,k),leftover{:});
                if ~isempty(cfg.text)
                    text(xgrid(1,k)+ts(1), xgrid(2,k)+ts(2), xgrid(3,k)+ts(3), cfg.text{k}, "Color", cfg.color(:,k));
                end
            end
        end
    end
    colormap(gray)
end