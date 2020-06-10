function x = get_points(meas, idx)
    get_fns = containers.Map();
    get_fns('rgn') = @get_from_rgn;
    get_fns('arc') = @get_from_arc;

    x = [];

    for key = meas.keys
        key = key{1};
        meas_key = meas(key);
        if ~isempty(meas_key)
            get_fn = get_fns(key);
            if nargin < 2 || isempty(idx)
                x = [x get_fn(meas_key)];
            else
                if idx.isKey(key)
                    idx_key = idx(key);
                    x = [x get_fn(meas_key(:,[idx_key{:}]))];
                end
            end
        end
    end
end

function x = get_from_rgn(rgns)
    x = reshape(rgns, 3, []);
end

function x = get_from_arc(arcs)
    x = [];
    for k=1:numel(arcs)
        arc = arcs{k};
        x = [x arc(1:3,:)];
    end
end