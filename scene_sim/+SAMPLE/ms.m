function [meas_scene, meas_img, angles] = ms(mss_dict, wplane, hplane, cam, noise)
    % Generate minimal sample for given camera
    % Args:
    %   mss_dict -- dict of minimal sample sizes
    %               keys: 'rgn', 'arc', 'lineseg'
    meas_scene = containers.Map();
    meas_img = containers.Map();
    angles = containers.Map();
    for key = mss_dict.keys
        feature_type = key{1};
        nums = mss_dict(feature_type);
        for n=nums
            sample_fn = str2func(['SAMPLE.' feature_type]);
            if isKey(noise, feature_type) && noise(feature_type) > 0
                [X, x, phi] = sample_fn(n, wplane, hplane, cam, noise(feature_type));
            else
                [X, x, phi] = sample_fn(n, wplane, hplane, cam);
            end
            
            meas_scene(feature_type) = X;
            meas_img(feature_type) = x;
            angles(feature_type) = phi;
        end
    end
end
