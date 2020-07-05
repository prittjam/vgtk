function [meas_scene, meas_img, varinputs] = make_minimal_sample2(input_configs, wplane, hplane, cam, varargin)
    % Generate minimal sample for given camera

    mss = input_configs{unidrnd(numel(input_configs))};

    cfg.orthogonal_directions = true; 
    cfg = cmp_argparse(cfg, varargin{:});

    if cfg.orthogonal_directions
        directions = {[1;0], [0;1], [0;0]};
    else
        directions = {'rand', 'rand', 'rand'};
    end

    meas_scene = MEAS.make_empty_map();
    meas_img = MEAS.make_empty_map();  
    varinputs = MEAS.make_empty_map();
    k2=1;
    for key = {'rgn','arc','lineseg','linept'}
        feature_type = key{1};
        make_sample_fn = str2func(['MEAS.make_minimal_sample_' ...
                                                    feature_type]);
        cardinalities = mss(feature_type);
        X = [];
        x = [];
        varinput = [];
        for k1=1:numel(cardinalities)
            cardinality = cardinalities(k1);
            if nargout(make_sample_fn) == 3
                [X_, x_, varinput_] = make_sample_fn(cardinality,...
                                            wplane, hplane, cam,...
                                            directions{k2});
                varinput = [varinput varinput_];
            else
                [X_, x_] = make_sample_fn(cardinality,...
                                          wplane, hplane, cam,...
                                          directions{k2});
            end
            X = [X X_]; x = [x x_];
            k2 = k2+1;
        end
        meas_scene(feature_type) = X;
        meas_img(feature_type) = x;
        varinputs(feature_type) = varinput;
    end
end
