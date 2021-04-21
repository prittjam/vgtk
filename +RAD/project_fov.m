function rd = project_fov(R, Z, proj_params)
    d = sqrt(R.^2+Z.^2);
    R = R./d;
    Z = Z./d;

    w = proj_params(1);
    rd = atan2(2.*R.*tan(w/2),Z)./w;
end