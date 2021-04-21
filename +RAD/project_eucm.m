function rd = project_eucm(R, Z, proj_params)
    d = sqrt(R.^2+Z.^2);
    R = R./d;
    Z = Z./d;

    alpha = proj_params(1);
    xi = 1/(1-alpha)-1;
    beta = proj_params(2);

    % if xi > 0
    %     min_valid_Z = (-xi^2-1+abs(xi^2-1))./(2*xi);
    %     valid = Z >= min_valid_Z;
    % else
    %     valid = ones(1,numel(Z));
    % end

    d = sqrt(beta*R.^2 + Z.^2);
    Z2 = alpha*d + (1-alpha)*Z;
    valid = beta*R.^2 + Z.^2 > 0 & ~abs(Z2)<1e-5;
    rd(valid) = R(valid)./Z2(valid);
    rd(~valid) = NaN;
end