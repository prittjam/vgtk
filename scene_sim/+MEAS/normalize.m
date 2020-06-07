function [meas_norm, varinput_norm] = normalize(meas, K, varinput)
    norm_fns = containers.Map();
    norm_fns('rgn') = @RP2.normalize;
    norm_fns('arc') = @ARC.normalize;
    norm_fns('lineseg') = @RP2.normalize;
    norm_fns('linept') = @RP2.normalize;
    
    meas_norm = MEAS.make_empty_map();
    varinput_norm = MEAS.make_empty_map();
    for key = meas.keys
        key = key{1};
        norm_fn = norm_fns(key);
        if ~isempty(meas(key))
            if nargout(norm_fn) == 2
                [meas_norm(key), varinput_norm(key)] = ...
                            norm_fn(meas(key), K, varinput(key));
            else
                meas_norm(key) = norm_fn(meas(key), K);
            end
        end
    end
end