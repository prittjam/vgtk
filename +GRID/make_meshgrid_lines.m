function l = make_meshgrid_lines(wplane, hplane, gt, varargin)
    if nargin == 2
        gt = [];
    end
    cfg = struct('gridsize', 10);
    cfg = cmp_argparse(cfg, varargin{:});
    
    t = linspace(-0.5, 0.5, cfg.gridsize);
    Lx = [-ones(1,cfg.gridsize); zeros(1,cfg.gridsize); t];
    Ly = [zeros(1,cfg.gridsize); -ones(1,cfg.gridsize); t];
    L = [Lx Ly];
    A = [[wplane 0; 0 hplane] [0 0]'; 0 0 1];
    L = A' \ L;
    if ~isempty(gt)
        A = inv(CAM.make_fitz_normalization(gt.cc));
        q_norm = CAM.normalize_div(gt.q, A);
        l = LINE.distort_div(PT.renormI(gt.P' \ L), A, q_norm);
    else
        l = L;
    end
end