%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function lh = draw(l,varargin)

    [cfg, leftover] = cmp_argparse(struct('color',[]),varargin{:});
    color_flag = isvector(cfg.color) & isnumeric(cfg.color) & ~all(cfg.color<=1 & cfg.color>=0);
    if color_flag
        cfg.color(isnan(cfg.color)) = max(cfg.color)+1;
        N = max(cfg.color);
    else
        N = size(l,2);
    end
    colormap(hsv(N))
    cmap = colormap;

    axes(gca);
    v = axis;
    n = size(l,2);
    
    top = repmat(cross([v(1) v(3) 1]',[v(2) v(3) 1]'),1,n);
    bottom = repmat(cross([v(1) v(4) 1]',[v(2) v(4) 1]'),1,n);
    left = repmat(cross([v(1) v(3) 1]',[v(1) v(4) 1]'),1,n);
    right = repmat(cross([v(2) v(3) 1]',[v(2) v(4) 1]'),1,n);
    
    pts = [LINE.intersect(l,top);...
           LINE.intersect(l,bottom);...
           LINE.intersect(l,left);...
           LINE.intersect(l,right)];
    
    ia = [repmat((pts(1,:) > v(1)) & (pts(1,:) < v(2)),2,1);...
          repmat((pts(3,:) > v(1)) & (pts(3,:) < v(2)),2,1);...
          repmat((pts(6,:) > v(3)) & (pts(6,:) < v(4)),2,1);...
          repmat((pts(8,:) > v(3)) & (pts(8,:) < v(4)),2,1)];
    
    pts2 = reshape(pts(ia(:)),2,[]);
    
    xs = reshape(pts2(1,:),2,[]);
    ys = reshape(pts2(2,:),2,[]);
    
    for k=1:size(ys,2)
        hold on;
        if color_flag
            line(xs(:,k), ys(:,k), "Color", cmap(cfg.color(k),:), leftover{:});
        elseif isempty(cfg.color)
            line(xs(:,k), ys(:,k),  "Color", cmap(k,:), leftover{:});
        else
            line(xs(:,k), ys(:,k),  varargin{:});
        end
    end

    colormap(gray)