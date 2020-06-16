function x = make_meshgrid(wplane, hplane, gt, varargin)
    if nargin == 2
        gt = [];
    end
    cfg = struct('gridsize', 10);
    cfg = cmp_argparse(cfg, varargin{:});
    
    t = linspace(-0.5, 0.5, cfg.gridsize);
    [a, b] = meshgrid(t, t);
    X = transpose([a(:) b(:) ones(numel(a), 1)]);
    A = [[wplane 0; 0 hplane] [0 0]'; 0 0 1];
    X = A * X;
    if ~isempty(gt)
        A = inv(CAM.make_fitz_normalization(gt.cc));
        q_norm = CAM.normalize_div(gt.q, A);
        x = CAM.distort_div(PT.renormI(gt.P * X), A, q_norm);
    else
        x = X;
    end
end