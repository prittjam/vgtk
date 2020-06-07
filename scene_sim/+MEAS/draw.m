function draw(meas, idx, opt)
    if nargin < 3 || isempty(opt)
        opt = MEAS.make_empty_map();
        opt('rgn') = {'color', 'blue', 'linewidth', 2};
        opt('arc') = {'color', 'green', 'linewidth', 2};
        opt('lineseg') = {'color','red','linewidth', 2};
        opt('linept') = {'color', 'magenta', 'linewidth', 2};
    end

    plot_fns = containers.Map();
    plot_fns('rgn') = @GRID.draw;
    plot_fns('arc') = @ARC.draw;
    plot_fns('lineseg') = @GRID.draw;
    plot_fns('linept') = @GRID.draw;

    for key = meas.keys
        key = key{1};
        meas_key = meas(key);
        opt_key = opt(key);
        plot_fn = plot_fns(key);
        if ~isempty(meas_key)
            if nargin < 2 || isempty(idx)
                plot_fn(meas_key, opt_key{:});
            else
                idx_key = idx(key);
                plot_fn(meas_key(:,[idx_key{:}]), opt_key{:});
            end
        end
    end
end