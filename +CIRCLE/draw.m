function draw(c, varargin)
    % draws a circle c = [xc...; yc...; r...]

    [cfg, leftover] = cmp_argparse(struct('color',[]),varargin{:});

    num_pts = 500;

    t = linspace(0, 1, num_pts);
    color_flag = all(isvector(cfg.color) & isnumeric(cfg.color) & all(mod(cfg.color,1)==0) & (~all(cfg.color<=1 & cfg.color>=0)|(size(cfg.color,1)==1 & size(cfg.color,2)==size(c,2))));
    if color_flag
        cfg.color(isnan(cfg.color)) = max(cfg.color)+1;
        N = max(cfg.color);
    else
        N = size(c,2);
    end
    colormap(hsv(N))
    cmap = colormap;
    for k=1:size(c,2)
        cx = c(1,k);
        cy = c(2,k);
        R = c(3,k);
        phi = t .* 2 * pi;
        pts = [cx + R .* cos(phi);...
               cy + R .* sin(phi);...
               ones(1, num_pts)];
        hold on
        if color_flag
            plot(pts(1,:), pts(2,:), "Color", cmap(cfg.color(k),:), leftover{:});
        elseif isempty(cfg.color)
            plot(pts(1,:), pts(2,:), "Color", cmap(k,:), leftover{:});
        elseif size(cfg.color,1)==N
            plot(pts(1,:), pts(2,:), "Color",cfg.color(k,:),leftover{:});
        else
            plot(pts(1,:), pts(2,:), varargin{:});
        end
    end
    colormap(gray)
    axis equal
end