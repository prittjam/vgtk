function draw(xgrid, varargin)
    sz = 120;
    xgrid = PT.renormI(xgrid);
    hold on
    scatter(xgrid(1,:), xgrid(2,:), sz, 'filled', varargin{:});
end