function draw(xgrid, varargin)
    cfg.size = 50;
    [cfg, varargin] = cmp_argparse(cfg, varargin{:});
    if size(xgrid,1) > 2
        xgrid = PT.renormI(xgrid);
        if size(xgrid,1) > 3
            for k=1:size(xgrid,2)
                hold on
                plot(xgrid(1:3:end,k), xgrid(2:3:end,k), varargin{:});
            end
            xgrid = reshape(xgrid,3,[]);
        end
    end
    hold on
    scatter(xgrid(1,:), xgrid(2,:), cfg.size, 'filled', varargin{:});
end