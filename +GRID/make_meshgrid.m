function x = make_meshgrid(wplane, hplane, gt, varargin)
    if nargin == 2
        gt = [];
    end
    cfg = struct('n_pts', 10);
    cfg = cmp_argparse(cfg, varargin{:});
    
    t = linspace(-0.5, 0.5, cfg.n_pts);
    [a, b] = meshgrid(t, t);
    X = transpose([a(:) b(:) ones(numel(a), 1)]);
    A = [[wplane 0; 0 hplane] [0 0]'; 0 0 1];
    X = A * X;
    if ~isempty(gt)
        gt.A = inv(CAM.make_fitz_normalization(gt.cc));
        gt.q_norm = CAM.normalize_div(gt.q, gt.A);
        x = CAM.distort_div(PT.renormI(gt.P * X), gt.q_norm, gt.A);
    else
        x = X;
    end
end