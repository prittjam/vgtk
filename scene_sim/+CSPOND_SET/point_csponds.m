function [x,cspond,G] = point_csponds(N, w, h, varargin)
    % Set of point correspondences that are endpoints of
    % the segments of scene parallel lines
    
    cfg = struct('direction', 'rand', 'direction2', 'rand', 'regular', false);
    cfg = cmp_argparse(cfg,varargin{:});

    x1 = [0.1 * rand(2,1) - 0.2; 1];
    if strcmp(cfg.direction, 'rand')
        phi = rand() * pi;
        d1 = [cos(phi); sin(phi)];
    else
        d1 = cfg.direction / norm(cfg.direction);
    end
    x2 = [x1(1:2) +  0.5 * rand() * d1; 1];
    x0 = [x1; x2] .* ones(1,N);
    if strcmp(cfg.direction2, 'rand')
        phi = (1 + rand(1,N)) * 60;
        R = arrayfun(@(x) rotx(x), phi, 'UniformOutput', false);
        R = cellfun(@(x) x(2:end,2:end), R, 'UniformOutput', false);
        d2 = reshape(vertcat(R{:}) * d1, 2, []);
    else
        d2 = cfg.direction2;
    end
    d2 = d2 ./ norm(d2);
    x = [];
    if cfg.regular
        t = d2 .* (-N:2:N-1)/N .* 0.4;
    else
        t = d2 .* rand(1,N) .* 0.4;
    end
    A = Rt.params_to_mtx([zeros(1,N); t; ones(1,N)]);
    x = RP2.mtimesx(A, x0);

    M = [[w 0; 0 h] [0 0]';0 0 1];
    x = reshape(M*reshape(x,3,[]),6,[]);
    cspond = transpose(nchoosek(1:N,2));
    G = repmat(1,1,N);
end