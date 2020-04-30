function [FOV_degree, uplim_theta, m, xcrn] = calc_FOV(nx, ny, K,...
                                                rad_backproj_fn,...
                                                rad_backproj_params)
    xcrn = [1 1 1; nx 1 1; nx ny 1; 1 ny 1]';
    xcrn_norm = K \ xcrn;
    [m, ind] = max(vecnorm(xcrn_norm(1:2,:),2,1));
    [uplim, uplim_theta] = rad_backproj_fn(m, rad_backproj_params);
    FOV_degree = uplim_theta * 360 / pi;
    xcrn = xcrn(:,ind);
end