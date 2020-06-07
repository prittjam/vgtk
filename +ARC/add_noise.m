function [arcs_noisy, circles_noisy] = add_noise(arcs, sigma, circles, varargin)
    % Adds noise to circluar arcs
    %
    % Args:
    %   arcs -- cell array {[xc...; yc...; 1...]}
    %               homogeneous points on the arc
    %   sigma -- noise magnitude
    %   circles [3 x N] -- [xc...; yc...; R...] -- circle params

    cfg.twodimensional = true;
    cfg = cmp_argparse(cfg,varargin{:});
    
    if sigma > 0 || isempty(sigma)
        for k = 1:numel(arcs);
            xx = arcs{k};
            if cfg.twodimensional
                arcs_noisy{k} = GRID.add_noise(xx, sigma);
            else
                n = xx(1:2,:) - circles(1:2,k);
                n = n ./ sqrt(sum(n.^2));
                s = normrnd(0,sigma,1,size(n,2));
                arcs_noisy{k} = [xx(1:2,:)+s.*n;ones(1,size(xx,2))];
            end
        end
        [circles_noisy, ~, ~, p, n] = CIRCLE.fit(arcs_noisy);
        circles_noisy = [circles_noisy; p; n];
    else
        arcs_noisy = arcs;
        circles_noisy = circles;
    end
end