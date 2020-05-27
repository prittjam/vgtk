function [x,cspond,G] = point_line(N, w, h, varargin)
    cfg = struct('direction', 'rand', 'regular', false);
    cfg = cmp_argparse(cfg,varargin{:});
    x0 = [0.1 * rand(2,1) - 0.2; 1] .* ones(1,N);
    if strcmp(cfg.direction, 'rand')
        phi = rand() * pi;
        d = [cos(phi); sin(phi)];
    else
        d = cfg.direction / norm(cfg.direction);
    end
    x = [];
    if cfg.regular
        t = d .* (-N:2:N-1)/N .* 0.4;
    else
        t = d .* rand(1,N) .* 0.4;
    end
    A = Rt.params_to_mtx([zeros(1,N); t; ones(1,N)]);
    x = RP2.mtimesx(A, x0);

    M = [[w 0; 0 h] [0 0]';0 0 1];
    x = M * x;
    cspond = transpose(nchoosek(1:N,2));
    G = repmat(1,1,N);
end