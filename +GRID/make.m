function x = make(w, h, gridsize, varargin)
    cfg.centered = true;
    cfg = cmp_argparse(cfg, varargin{:});
    if cfg.centered
        t = linspace(-0.5, 0.5, gridsize);
    else
        t = linspace(0, 1, gridsize);
    end
    [a, b] = meshgrid(t, t);
    X = transpose([a(:) b(:) ones(numel(a), 1)]);
    A = [[w 0; 0 h] [0 0]'; 0 0 1];
    x = A * X;
end