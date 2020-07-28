function proj_params = unnormalize_sc(proj_params, K)
    % proj_params -- [a0 a2 a3 a4 cx cy]

    f = K(1,1);
    proj_params(2) = proj_params(2) / (f^2);
    proj_params(3) = proj_params(3) / (f^3);
    proj_params(4) = proj_params(4) / (f^4);

    if numel(proj_params) > 4
        cc = proj_params(5:6)';
        cc = K * [cc; 1];
        proj_params(5:6) = cc(1:2);
    end
end
