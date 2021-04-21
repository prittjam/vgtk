function proj_params = normalize_rat(proj_params, K)
    %   proj_params -- [mu1...muk lambda1...lambdak] in mm

    % mu = proj_params(1:numel(proj_params)/2);
    % lambda = proj_params(numel(proj_params)/2+1:end);
    lambda = proj_params;
    pows = 1:size(lambda,2);
    f = K(1,1);

    lambda = lambda .* (f^2).^pows;
    % mu = mu .* (f^2).^pows;
    % proj_params = [mu lambda];
    proj_params = [lambda];
end
