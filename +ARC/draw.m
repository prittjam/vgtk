function draw(arcs, varargin)
    % arcs -- {3 x arc_length} x num_arcs

    [cfg, leftover] = cmp_argparse(struct('color',[],'linewidth',2),varargin{:});

    color_flag = all(isvector(cfg.color) & isnumeric(cfg.color) & all(mod(cfg.color,1)==0) & (~all(cfg.color<=1 & cfg.color>=0)|(size(cfg.color,1)==1 & size(cfg.color,2)==numel(arcs))));
    if color_flag
        cfg.color(isnan(cfg.color)) = max(cfg.color)+1;
        N = max(cfg.color);
    else
        N = numel(arcs);
    end
    colormap(hsv(N))
    cmap = colormap;
    for k=1:numel(arcs)
        pts = arcs{k};
        hold on
        if color_flag
            plot(pts(1,:), pts(2,:), "Color", cmap(cfg.color(k),:), 'linewidth',cfg.linewidth,leftover{:});
            GRID.draw(pts(:,round((size(pts,2)+1)/2)), 'color', cmap(cfg.color(k),:),'linewidth',cfg.linewidth, leftover{:});
        elseif isempty(cfg.color)
            plot(pts(1,:), pts(2,:), "Color", cmap(k,:), 'linewidth',cfg.linewidth,leftover{:});
        elseif size(cfg.color,1)==N
            plot(pts(1,:), pts(2,:),"Color",cfg.color(k,:),'linewidth',cfg.linewidth,leftover{:});
        else
            plot(pts(1,:), pts(2,:),'linewidth',cfg.linewidth,varargin{:});
        end
    end
    hold off;
    colormap(gray)

    