function proj_params = normalize_sc(proj_params, K)
    % proj_params -- [a0 a2 a3 a4 cx cy]

    sc = K(1,1);
    a = proj_params / sc;
    a(2) = a(2) * (sc^2);
    a(3) = a(3) * (sc^(3/2));
    a(4) = a(4) * (sc^4);
    proj_params = a;
end