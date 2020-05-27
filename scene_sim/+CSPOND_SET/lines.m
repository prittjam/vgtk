function [L, S, Lcspond, LG] = lines(N, w, h, varargin)
    % Creates a corresponded set of N lines (N parallel lines)
    % that intersect scene plane
    % which is [-(w-1)/2; (w-1)/2] x [-(h-1)/2; (h-1)/2]
    % Args:
    %   N -- number of lines in the corresponded set
    %   w -- width
    %   h -- height
    % Returns:
    %   L -- lines
    %        array 3xN: [L1, L2,...]
    %   S -- endpoints of the segments
    %        array 3x(2*N): [S1_e1, S1_e2, S2_e1, S2_e2,...]
    %   Lcspond -- correspondences
    %   LG -- clusters

    cfg = struct('direction', 'rand',...
                 'simple', false,...
                 'regular', false);
    cfg = cmp_argparse(cfg,varargin{:});

    % Lines
    sizes = [w; h];
    if strcmp(cfg.direction, 'rand')
        l12 = rand(2, 1) * 9 + 1;
    else
        d = cfg.direction;
        l12 = [d(2); -d(1)];
    end
    borders = [-(w-1)/2 -(w-1)/2 (w-1)/2 (w-1)/2; -(h-1)/2 (h-1)/2 -(h-1)/2 (h-1)/2];
    l3_lower_bound = min(-borders' * l12);
    l3_upper_bound = max(-borders' * l12);
    % l3_lower_bound = max(-l12 .* ((sizes-1) / 2), [], 1);
    % l3_upper_bound = min(l12 .* ((sizes-1) / 2), [], 1);
    l3_diff = l3_upper_bound - l3_lower_bound;
    if cfg.simple
        if cfg.regular
            l3 = (-N:2:N-1)/N .* l3_diff + l3_lower_bound; 
        else   
            l3 = rand(1, N) .* l3_diff + l3_lower_bound;
        end
    else
        %% With some distance in-between (TODO: simplify code)
        flag = false;
        iter = 1;
        while ~flag && iter < 100;
            mindist = ceil(0.07 * min(sizes) * sqrt(sum(l12 .^2)));
            maxrange = max(floor(l3_diff - (N - 1) * mindist) - 1,2*N);
            l3 = (0:N-1) .* mindist + sort(randperm(maxrange, N)) + l3_lower_bound;
            flag = all(l3 >= l3_lower_bound) && all(l3 <= l3_upper_bound);
            iter = iter+1;
        end
        if iter >= 100
            l3 = rand(1, N) .* l3_diff + l3_lower_bound;
        end
    end

    L = [ones(1, N) .* l12; l3]; % 3 x N: [L1, L2,...]
    
    % Segments
    v = [-w/2 w/2 -h/2 h/2];

    top = repmat(cross([v(1) v(3) 1]', [v(2) v(3) 1]'), 1, N);
    bottom = repmat(cross([v(1) v(4) 1]', [v(2) v(4) 1]'), 1, N);
    left = repmat(cross([v(1) v(3) 1]', [v(1) v(4) 1]'), 1, N);
    right = repmat(cross([v(2) v(3) 1]', [v(2) v(4) 1]'), 1, N);

    pts = [LINE.intersect(L, top);...
           LINE.intersect(L, bottom);...
           LINE.intersect(L, left);...
           LINE.intersect(L, right)];

    ia = [repmat((pts(1,:) > v(1)) & (pts(1,:) < v(2)), 2, 1);...
          repmat((pts(3,:) > v(1)) & (pts(3,:) < v(2)), 2, 1);...
          repmat((pts(6,:) > v(3)) & (pts(6,:) < v(4)), 2, 1);...
          repmat((pts(8,:) > v(3)) & (pts(8,:) < v(4)), 2, 1)];

    edges = reshape(pts(ia(:)),2,[]); % 2 x N [L1_start, L1_end, L2_start, L2_end ...]
    edges = reshape(edges, 4, N);

    k0 = rand(1, N) * 0.3;
    k1 = rand(1, N) * 0.3 + 0.7;

    s0 = edges(1:2,:) + k0 .* (edges(3:4,:) - edges(1:2,:)); % 1st endpoints of the segments, 2 x N
    s1 = edges(1:2,:) + k1 .* (edges(3:4,:) - edges(1:2,:)); % 2nd endpoints of the segments, 2 x N

    S = [PT.homogenize(s0); PT.homogenize(s1)]; % 6 x 2 * N
    S = reshape(S, 3, []); % 3 x 2 * N [S1_e1, S1_e2, S2_e1, S2_e2 ...] -- endpoints of the segments

    Lcspond = nchoosek(1:N, 2)';
    LG = repmat(1, 1, N);
end