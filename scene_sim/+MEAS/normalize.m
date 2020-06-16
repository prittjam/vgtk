function [meas2, varinput2] = normalize(meas, K, varinput)
    norm_fns = containers.Map();
    norm_fns('rgn') = @RP2.normalize;
    norm_fns('arc') = @ARC.normalize;
    norm_fns('lineseg') = @RP2.normalize;
    norm_fns('linept') = @RP2.normalize;
    
    meas2 = MEAS.make_empty_map();
    if nargout == 2
        varinput2 = MEAS.make_empty_map();
    end
    for key = meas.keys
        key = key{1};
        norm_fn = norm_fns(key);
        if ~isempty(meas(key))
            if nargout(norm_fn) == 2
                [meas2(key), varinput2(key)] = ...
                            norm_fn(meas(key), K, varinput(key));
            else
                meas2(key) = norm_fn(meas(key), K);
                varinput2(key) = varinput(key);
            end
        end
    end
end