function [meas_noisy, varinput_noisy] = add_noise(meas, noise,...
                                                  varinput)
    add_noise_fns = containers.Map();
    add_noise_fns('rgn') = @RP2.add_noise;
    add_noise_fns('arc') = @ARC.add_noise;
    add_noise_fns('lineseg') = @RP2.add_noise;
    add_noise_fns('linept') = @RP2.add_noise;
    
    meas_noisy = meas;
    varinput_noisy = varinput;
    for key = meas.keys
        key = key{1};
        add_noise_fn = add_noise_fns(key);
        if ~isempty(meas(key)) && ~isempty(noise(key))
            if nargout(add_noise_fn) == 2
                [meas_noisy(key), varinput_noisy(key)] = ...
                            add_noise_fn(meas(key), noise(key), varinput(key));
            else
                meas_noisy(key) = add_noise_fn(meas(key), noise(key));
            end
        end
    end
end