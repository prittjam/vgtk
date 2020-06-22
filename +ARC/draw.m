function draw(arcs, varargin)
    % arcs -- {3 x arc_length} x num_arcs

    [cfg, leftover] = cmp_argparse(struct('color',[]),varargin{:});

    color_flag = isvector(cfg.color) & isnumeric(cfg.color) & ~all(cfg.color<=1 & cfg.color>=0);
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
            plot(pts(1,:), pts(2,:), "Color", cmap(cfg.color(k),:), leftover{:});
            GRID.draw(pts(:,round((size(pts,2)+1)/2)), 'color', cmap(cfg.color(k),:), leftover{:});
        elseif isempty(cfg.color)
            plot(pts(1,:), pts(2,:), "Color", cmap(k,:), leftover{:});
            % GRID.draw(pts(:,round((size(pts,2)+1)/2)), 'color', cmap(k,:), leftover{:});
        else
            plot(pts(1,:), pts(2,:), varargin{:});
            % GRID.draw(pts(:,round((size(pts,2)+1)/2)), varargin{:});
        end
    end
    hold off;

    