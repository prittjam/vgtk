function [HFOV, VFOV, DFOV] = calc_FOV(nx, ny, K,...
                                        rad_backproj_fn,...
                                        rad_backproj_params)
    % HFOV
    x = [1 K(2,3) 1; nx K(2,3) 1]';
    x_norm = K \ x;
    rs = vecnorm(x_norm(1:2,:),2,1);
    [~, theta] = rad_backproj_fn(rs, rad_backproj_params);
    HFOV = sum(theta) * 180 / pi;

    % VFOV
    x = [K(1,3) 1 1; K(1,3) ny 1]';
    x_norm = K \ x;
    rs = vecnorm(x_norm(1:2,:),2,1);
    [~, theta] = rad_backproj_fn(rs, rad_backproj_params);
    VFOV = sum(theta) * 180 / pi;

    % DFOV
    xcrn1 = [1 1 1; nx ny 1]';
    xcrn_norm1 = K \ xcrn1;
    rs1 = vecnorm(xcrn_norm1(1:2,:),2,1);
    [~, theta1] = rad_backproj_fn(rs1, rad_backproj_params);
    DFOV1 = sum(theta1) * 180 / pi;

    xcrn2 = [nx 1 1; 1 ny 1]';
    xcrn_norm2 = K \ xcrn2;
    rs2 = vecnorm(xcrn_norm2(1:2,:),2,1);
    [~, theta2] = rad_backproj_fn(rs2, rad_backproj_params);
    DFOV2 = sum(theta2) * 180 / pi;

    DFOV = min(DFOV1, DFOV2);
end

function [DFOV, uplim, uplim_theta] = calc_max_r(nx, ny, K,...
                                    rad_backproj_fn,...
                                    rad_backproj_params)
    xcrn = [1 1 1; nx 1 1; nx ny 1; 1 ny 1]';
    xcrn_norm = K \ xcrn;
    rs = vecnorm(xcrn_norm(1:2,:),2,1);
    [rmax, ind] = max(rs);
    [uplim, uplim_theta] = rad_backproj_fn(rmax, rad_backproj_params);
    DFOV = uplim_theta * 360 / pi;
    xcrn = xcrn(:,ind);
end