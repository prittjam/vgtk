function arc_list_noisy = add_noise(arc_list,c,varargin)
    % Adds noise to circluar arcs
    % Args:
    % arc_list -- cell array {[xc...; yc...; 1...]} -- homogeneous points on the arc
    % c [3 x N] -- [xc...; yc...; R...] -- circle params
    cfg.sigma = 0;
    cfg = cmp_argparse(cfg,varargin{:});
    
    if cfg.sigma > 0
        for k = 1:numel(arc_list);
            xx = arc_list{k};
            n = xx(1:2,:) - c(1:2,k);
            n = n ./ sqrt(sum(n.^2));
            s = normrnd(0,cfg.sigma,1,size(n,2));
            arc_list_noisy{k} = [xx(1:2,:)+s.*n;ones(1,size(xx,2))];
        end
    else
        arc_list_noisy = arc_list;
    end
end