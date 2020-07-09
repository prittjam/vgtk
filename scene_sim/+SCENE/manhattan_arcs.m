function [cam, circles, arcs, vp_labels] = manhattan_arcs()
    e = eye(3);

    N = [5 5 5];

    q = -1.5;
    f_mm = 5;
    ccd_mm = 4.8;
    cam = CAM.make_ccd(f_mm, ccd_mm, 1000, 1000);
    cam = CAM.make_lens(cam, q, 'div');
    cam = CAM.make_viewpoint(cam);

    cam.vp = cam.P34 * [e; zeros(1,3)];

    wplane = 10;
    hplane = 10;

    lines = [];
    endpoints = [];
    for ix=1:numel(N)
        if (e(1,ix)<1e-11) && (e(2,ix)<1e-11)
            [L, S] = CSPOND_SET.lines(N(ix), wplane, hplane,...
            'direction', [1;0;0], 'regular', true);
            l = cam.P34(:, [3 1 4])' \ L;
            s = RP2.mtimesx(cam.P34(:, [3 1 4]), reshape(S,6,[]));
        else
            [L, S] = CSPOND_SET.lines(N(ix), wplane, hplane,...
                'direction', e(:,ix), 'regular', true);
            l = cam.P' \ L;
            s = RP2.mtimesx(cam.P, reshape(S,6,[]));
        end
        lines = [lines l];
        endpoints = [endpoints s];
    end

    project_fn = str2func(['LINE.' cam.proj_fn]);
    circles = project_fn(lines, cam.K, cam.proj_params);
    project_fn = str2func(['RP2.' cam.proj_fn]);
    s = project_fn(endpoints, cam.K, cam.proj_params);
    [p, n] = ARC.get_midpoint(circles, s);
    arcs = ARC.sample(circles, s, 'num_pts', 100);

    vp_labels = [ones(1,N(1)) 2*ones(1,N(2)) 3*ones(1,N(3))];

    vp = project_fn(cam.vp, cam.K, cam.proj_params);

    circles_norm = CIRCLE.normalize(circles, cam.K);
    arcs_norm = ARC.normalize(arcs, cam.K);
    vp_norm = RP2.normalize(vp, cam.K);
    
    % %%%%%%%%%%%%%%%% DRAW UNDISTORTED
    % close all
    % LINE.draw(gca,lines,'Color','b')
    % ARC.draw(arcs,'LineWidth',2,'Color',vp_labels,'MarkerSize',10)
    % GRID.draw(s,'Color',vp_labels,'Size',10)
    % GRID.draw(cam.vp,'Size',30)
    % axis equal
    % keyboard
    % %%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%% DRAW DISTORTED
    % close all
    % CIRCLE.draw(circles,'Color',vp_labels)
    % ARC.draw(arcs,'LineWidth',2,'Color',vp_labels,'MarkerSize',10)
    % GRID.draw(s,'Color',vp_labels,'Size',10)
    % GRID.draw(vp,'Size',30)
    % axis equal
    % keyboard
    % %%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%% DRAW NORM
    % close all
    % figure
    % CIRCLE.draw(circles_norm,'Color',vp_labels)
    % ARC.draw(arcs_norm,'LineWidth',2,'Color',vp_labels,'MarkerSize',10)
    % GRID.draw(vp_norm,'Size',30)
    % axis equal
    % keyboard
    % %%%%%%%%%%%%%%%%

    % gt = struct();
    % gt.K = cam.K;
    % gt.R = cam.R;
    % gt.t = cam.c;
    % gt.vp_ud = cam.vp;
    % gt.vp = vp;
    % gt.vp_norm = vp_norm;
    % gt.q = cam.proj_params;
    % gt.imsize_x = cam.nx;
    % gt.imsize_y = cam.ny;
    % gt.circles = circles;
    % gt.circles_norm = circles_norm;
    % gt.arcs = [arcs{:}];
    % gt.arcs_norm = [arcs_norm{:}];
    % gt.vp_labels = vp_labels;
    % savejson2(gt, GetFullPath('~/gt.json'));
end
