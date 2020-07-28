function proj_params = normalize_div(proj_params, K)
    % proj_params -- [q cx cy]
    
    f = K(1,1);
    proj_params(1) = proj_params(1) * (f^2);

    if numel(proj_params) > 1
        cc = proj_params(2:3)';
        cc = K \ [cc; 1];
        proj_params(2:3) = cc(1:2);
    end
end