function meas_norm = normalize(meas, K)
    norm_fns = containers.Map(...
            {'rgn', 'arc', 'lineseg', 'linept'},...
            {@RP2.normalize, @CIRCLE.normalize, @RP2.normalize, @RP2.normalize},...
            'isUniform', false);
    meas_norm = containers.Map();
    for key = meas.keys
        key = key{1};
        norm_fn = norm_fns(key);
        meas_norm(key) = norm_fn(meas(key), K);
    end
end