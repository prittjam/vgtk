function draw(meas, varinput, idx, opt, varinput_opt, keys)
    if nargin < 2 || isempty(varinput)
        varinput = MEAS.make_empty_map();
    end
    if nargin < 4 || isempty(opt)
        opt = MEAS.make_empty_map();
        opt('rgn') = {'color', 'blue', 'linewidth', 2};
        opt('arc') = {'color', 'green', 'linewidth', 2};
        opt('lineseg') = {'color','red','linewidth', 2};
        opt('linept') = {'color', 'magenta', 'linewidth', 2};
    end
    if nargin < 5 || isempty(varinput_opt)
        varinput_opt = MEAS.make_empty_map();
        varinput_opt('arc') = {'color', 'green', 'linewidth', 0.8,...
                               'LineStyle', '--'};
    end
    if nargin<6 || isempty(keys)
        keys = meas.keys;
    end

    plot_fns = containers.Map();
    plot_fns('rgn') = @GRID.draw;
    plot_fns('arc') = @ARC.draw;
    plot_fns('lineseg') = @GRID.draw;
    plot_fns('linept') = @GRID.draw;

    varinput_plot_fns = containers.Map();
    varinput_plot_fns('arc') = @CIRCLE.draw;

    for key = keys
        key = key{1};
        meas_key = meas(key);
        if ~isempty(meas_key)
            opt_key = opt(key);
            plot_fn = plot_fns(key);
            if nargin < 3 || isempty(idx)
                plot_fn(meas_key, opt_key{:});
            else
                if idx.isKey(key)
                    idx_key = idx(key);
                    plot_fn(meas_key(:,[idx_key{:}]), opt_key{:});
                end
            end
        end

        varinput_key = varinput(key);
        if ~isempty(varinput_key)
            varinput_opt_key = varinput_opt(key);
            varinput_plot_fn = varinput_plot_fns(key);
            if nargin < 3 || isempty(idx)
                varinput_plot_fn(varinput_key, varinput_opt_key{:});
            else
                idx_key = idx(key);
                varinput_plot_fn(varinput_key(:,[idx_key{:}]), varinput_opt_key{:});
            end
        end
    end
    axis equal
end