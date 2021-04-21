function [HFOV, VFOV, DFOV] = calc_FOV(nx, ny, K,...
                                        rad_backproj_fn,...
                                        proj_params,...
                                        varargin)
    cfg = struct('units', 'degrees', 'fisheye', false, 'img', []);
    cfg = cmp_argparse(cfg, varargin{:});
    if cfg.fisheye
        assert(~isempty(cfg.img));
        % c_pts = imcontour(im2bw(imgaussfilt(cfg.img,1),0.085),1);
        close all
        % c_pts = c_pts(:,c_pts(1,:)>0 & c_pts(2,:)>0);
        % c_pts = c_pts(:,c_pts(1,:)<=nx & c_pts(2,:)<=ny);
        % c = CIRCLE.fit({c_pts});
        % rect = [max(c(1:2,:)-c(3,:),0) min(c(1:2,:)+c(3,:), [nx; ny])]; %[x1 x2; y1 y2]
        % imshow(cfg.img)
        % CIRCLE.draw(c)
        imshow(cfg.img)
        % rect = ginput(2)';
        % x0 = min(rect(1,:));
        % x1 = max(rect(1,:));
        % K(1,3) = K(1,3) - x0;
        % nx = x1 - x0;
        title('Please click on some edge point of the image.')
        x = ginput(1)';
        x_norm = K \ [x;1];
        [~, theta] = rad_backproj_fn(vecnorm(x_norm(1:2)), proj_params);
        DFOV = theta*2;
        % KannalaBrandt().radial_profile(proj_params,true,theta)
        % keyboard
    else
        % HFOV
        x = [1 K(2,3) 1; nx K(2,3) 1]';
        x_norm = K \ x;
        rs = vecnorm(x_norm(1:2,:),2,1);
        [~, theta] = rad_backproj_fn(rs, proj_params);
        HFOV = sum(theta);

        % VFOV
        x = [K(1,3) 1 1; K(1,3) ny 1]';
        x_norm = K \ x;
        rs = vecnorm(x_norm(1:2,:),2,1);
        [~, theta] = rad_backproj_fn(rs, proj_params);
        VFOV = sum(theta);

        % DFOV
        xcrn1 = [1 1 1; nx ny 1]';
        xcrn_norm1 = K \ xcrn1;
        rs1 = vecnorm(xcrn_norm1(1:2,:),2,1);
        [~, theta1] = rad_backproj_fn(rs1, proj_params);
        DFOV1 = sum(theta1);

        xcrn2 = [nx 1 1; 1 ny 1]';
        xcrn_norm2 = K \ xcrn2;
        rs2 = vecnorm(xcrn_norm2(1:2,:),2,1);
        [~, theta2] = rad_backproj_fn(rs2, proj_params);
        DFOV2 = sum(theta2);

        DFOV = min(DFOV1, DFOV2);
    end

    if cfg.fisheye
        VFOV = DFOV;
        HFOV = DFOV;
    end
    if strcmp(cfg.units, 'degrees')
        HFOV = HFOV * 180 / pi;
        VFOV = VFOV * 180 / pi;
        DFOV = DFOV * 180 / pi;
    end
end

function [DFOV, uplim, uplim_theta] = calc_max_r(nx, ny, K,...
                                    rad_backproj_fn,...
                                    proj_params)
    xcrn = [1 1 1; nx 1 1; nx ny 1; 1 ny 1]';
    xcrn_norm = K \ xcrn;
    rs = vecnorm(xcrn_norm(1:2,:),2,1);
    [rmax, ind] = max(rs);
    [uplim, uplim_theta] = rad_backproj_fn(rmax, proj_params);
    DFOV = uplim_theta * 360 / pi;
    xcrn = xcrn(:,ind);
end