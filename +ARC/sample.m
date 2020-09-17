function arc_list = sample(c, s, varargin)
    % Samples the points on the arc given its circle params
    % (center, radius) and the endpoints
    %
    % Args:
    %   c -- circle params, array 3xN: [xc...; yc...; R...]
    %   s -- endpoints, array 4xN: [x1...; y1...; x2...; y2...]
    % Returns:
    %   arc_list -- list of sampled circular arcs
    if nargin > 1 && ~isempty(s) && size(s,1) == 6
        s = RP2.inhomogenize(s);
        assert(all(CIRCLE.belongs(s(1:2,:), c)))
        assert(all(CIRCLE.belongs(s(3:4,:), c)))
    end


    cfg.num_pts = 100;
    cfg = cmp_argparse(cfg, varargin{:});

    N = size(c,2);
    if numel(cfg.num_pts) == 1
        cfg.num_pts = ones(1,N) * cfg.num_pts;
    end
    if nargin<2
        x1 = rand(1,N) .* 2 - 1;
        y1 = ((rand(1,N) > 0.5) .* 2 - 1) .* sqrt(1 - x1);
        x2 = x1 + 0.2 * (rand(1,N) + 1);
        y2 = sign(y1) .* sqrt(1 - x1);
        x1 = x1 .* c(3,:) + c(1,:);
        x2 = x2 .* c(3,:) + c(1,:);
        y1 = y1 .* c(3,:) + c(2,:);
        y2 = y2 .* c(3,:) + c(2,:);
        s = [x1; y1; x2; y2];
    end
    for k=1:N
        cntr = c(1:2,k);
        R = c(3,k);
        if nargin > 1 && ~isempty(s)
            s1 = s(1:2,k);
            s2 = s(3:4,k);
            phi1 = atan2(s1(2) - cntr(2), s1(1) - cntr(1));
            phi2 = atan2(s2(2) - cntr(2), s2(1) - cntr(1));
            dphi = phi2 - phi1;
            dphi = mod((dphi + pi), 2 * pi) - pi;
        else
            phi1 = 0;
            dphi = 2*pi;
        end
        t = linspace(0,1,cfg.num_pts(k));
        phi = t .* dphi + phi1;
        arc_list{k} = [cntr(1) + R .* cos(phi); cntr(2) + R .* sin(phi); ones(1,cfg.num_pts(k))];
    end
end