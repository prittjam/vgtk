function [meas_new, varinput_new] = get(meas, idx, varinput)
    meas_new = MEAS.make_empty_map();
    varinput_new = MEAS.make_empty_map();
    for key = idx.keys
        key = key{1};
        meas_key = meas(key);
        varinput_key = varinput(key);
        idx_key = idx(key);
        meas_new(key) = meas_key(:,[idx_key{:}]);
        varinput_new(key) = varinput_key(:,[idx_key{:}]);
    end
end