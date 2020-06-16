function [meas2, varinput2] = add_noise(meas, noise,...
                                                  varinput)
    add_noise_fns = containers.Map();
    add_noise_fns('rgn') = @RP2.add_noise;
    add_noise_fns('arc') = @ARC.add_noise;
    add_noise_fns('lineseg') = @RP2.add_noise;
    add_noise_fns('linept') = @RP2.add_noise;
    
    meas2 = MEAS.make_empty_map();
    if nargout == 2
        varinput2 = MEAS.make_empty_map();
    end
    for key = meas.keys
        key = key{1};
        add_noise_fn = add_noise_fns(key);
        if ~isempty(meas(key)) && ~isempty(noise(key))
            if nargout(add_noise_fn) == 2
                [meas2(key), varinput2(key)] = ...
                            add_noise_fn(meas(key), noise(key), varinput(key));
            else
                meas2(key) = add_noise_fn(meas(key), noise(key));
                varinput2(key) = varinput(key);
            end
        else
            meas2(key) = meas(key);
            if nargout == 2
                varinput2(key) = varinput(key);
            end
        end
    end
end