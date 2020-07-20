function gt = manhattan_arcs()
    e = eye(3);

    N = [5 5 5];

    q = -1.5;
    f_mm = 5;
    ccd_mm = 4.8;
    cam = CAM.make_ccd(f_mm, ccd_mm, 1000, 1000);
    cam = CAM.make_lens(cam, q, 'div');
    cam = CAM.make_viewpoint(cam);

    cam.vp_ud = cam.P34 * [e; zeros(1,3)];

    cc = [570; 520];
    T = cam.K;
    T(1:2,3) = cc;

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
    circles = project_fn(lines, T, cam.proj_params);
    project_fn = str2func(['RP2.' cam.proj_fn]);
    s = project_fn(endpoints, T, cam.proj_params);
    [p, n] = ARC.get_midpoint(circles, s);
    arcs = ARC.sample(circles, s, 'num_pts', 100);

    vp_labels = [ones(1,N(1)) 2*ones(1,N(2)) 3*ones(1,N(3))];

    vp = project_fn(cam.vp_ud, T, cam.proj_params);

    circles_norm = CIRCLE.normalize(circles, T);
    arcs_norm = ARC.normalize(arcs, T);
    vp_norm = RP2.normalize(vp, T);
    

    gt = struct();
    gt.K = cam.K;
    gt.R = cam.R;
    gt.t = cam.c;
    gt.cc = cc;
    gt.vp_ud = cam.vp_ud;
    gt.vp = vp;
    % gt.vp_norm = vp_norm;
    gt.q = cam.proj_params;
    gt.imsize_x = cam.nx;
    gt.imsize_y = cam.ny;
    gt.circles = circles;
    % gt.circles_norm = circles_norm;
    gt.arcs = arcs;
    % gt.arcs_norm = [arcs_norm{:}];
    gt.vp_labels = vp_labels;
    % savejson2(gt, GetFullPath('~/gt.json'));
    % save('~/gt.mat', 'gt')
    % keyboard

    % %%%%%%%%%%%%%%%% DRAW DISTORTED
    % close all
    % CIRCLE.draw(gt.circles,'Color',gt.vp_labels)
    % ARC.draw(gt.arcs,'LineWidth',2,'Color',gt.vp_labels,'MarkerSize',10)
    % GRID.draw(gt.vp,'Size',30)
    % GRID.draw([gt.cc; 1],'Size',30,'Color','k')
    % axis equal
    % keyboard
    % %%%%%%%%%%%%%%%%
end
