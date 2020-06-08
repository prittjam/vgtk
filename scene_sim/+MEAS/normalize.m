function [meas, varinput] = normalize(meas, K, varinput)
    norm_fns = containers.Map();
    norm_fns('rgn') = @RP2.normalize;
    norm_fns('arc') = @ARC.normalize;
    norm_fns('lineseg') = @RP2.normalize;
    norm_fns('linept') = @RP2.normalize;
    
    for key = meas.keys
        key = key{1};
        norm_fn = norm_fns(key);
        if ~isempty(meas(key))
            if nargout(norm_fn) == 2
                [meas(key), varinput(key)] = ...
                            norm_fn(meas(key), K, varinput(key));
            else
                meas(key) = norm_fn(meas(key), K);
            end
        end
    end
end