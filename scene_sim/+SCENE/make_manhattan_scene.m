function [cam, xd, Gapp, Gvpx, c, s, arcs, Gvpc, P34, X, L, S, uvw] = make_manhattan_scene(varargin)
    repeats_init;
    cfg = struct('nx', 1000, ...
                 'ny', 1000,...
                 'n_lines_min', 2,...
                 'n_lines_max', 10,...
                 'n_lafs_min', 2,...
                 'n_lafs_max', 10,...
                 'n_laf_groups_max', 5,...
                 'cc', [], ...
                 'q', -4,...
                 'regular', true);
    cfg = cmp_argparse(cfg,varargin{:});

    if isempty(cfg.cc)
        cc = [cfg.nx/2+0.5; ...
              cfg.ny/2+0.5];
    else
        cc = cfg.cc;%
    end    
    
    wplane = 10;
    hplane = 10;

    f = 5*rand(1)+3;
    ccd_mm = 4.8;
    cam = CAM.make_ccd(f,ccd_mm,cfg.nx,cfg.ny);
    f_gt = cam.f;
    [P,~,P34,R,c] = PLANE.make_viewpoint(cam); 
    q = cfg.q / (sum(2*cam.cc)^2);
    cam.q = q;
    gt = PLANE.make_Rt_gt(1, P, q, cam.cc, 0, P34, R, c);

    U = [rand(2,1); 0];  
    V = [U(2); -U(1); 0];

    % Lines
    [L, S, ~, Gvpc] = PLANE.make_cspond_set_lines_t(randi([cfg.n_lines_min, cfg.n_lines_max]),...
                                                    wplane, hplane, 'direction', U(1:2),...
                                                    'regular', cfg.regular);
    [L1, S1, ~, Gvpc1] = PLANE.make_cspond_set_lines_t(randi([2,cfg.n_lines_max]),...
                                                       wplane, hplane, 'direction', V(1:2),...
                                                       'regular', cfg.regular);
    L = [L L1];
    S = [S S1];
    Gvpc = [Gvpc Gvpc1+max(Gvpc)];

    % LAFs
    [X, ~, Gapp] = PLANE.make_cspond_set_t(randi([cfg.n_lafs_min, cfg.n_lafs_max]),...
                                           wplane, hplane, 'direction', V(1:2),...
                                           'regular', cfg.regular);
    Gvpx = ones(1,size(X,2)) * 2;
    if cfg.n_laf_groups_max > 1
        n_lafG = randi(cfg.n_laf_groups_max-1);
        for i=1:n_lafG
            if (rand() < 0.5); d = U(1:2); l = 1; else; d = V(1:2); l = 2; end
            [X1, ~, Gapp1] = PLANE.make_cspond_set_t(randi([2,cfg.n_lafs_max]),...
                                            wplane, hplane, 'direction', d,...
                                            'regular', cfg.regular);
            X = [X X1];
            Gapp = [Gapp Gapp1+max(Gapp)];
            Gvpx = [Gvpx ones(1,size(X1,2)) * l];
        end
    end
    
    % check
    % assert(dot(U, V) < 1e-13);
    
    u = PT.renormI(P * U);
    v = PT.renormI(P * V);
    W = cross(cam.K \ u, cam.K \ v);
    w = PT.renormI(cam.K * W);
    uvw =[u v w];

    % check
    omega_ = cam.K * cam.K';
    % assert(dot(u, omega_ \ v) < 1e-13);
    % assert(dot(u, omega_ \ w) < 1e-13);
    % assert(dot(v, omega_ \ w) < 1e-13);

    x = RP2.renormI(blkdiag(P,P,P)*X);
    q_gt = cfg.q/(sum(2*cc)^2);
    xd = CAM.distort_div(reshape(x,3,[]), cam.A, cam.q_norm);
    xd = reshape(xd,9,[]); 

    c = LINE.distort_div(P' \ L, gt.A, gt.q_norm);

    s = CAM.distort_div(PT.renormI(P * S), cam.A, gt.q_norm);
    arcs = ARC.sample2(c, reshape(s(1:2,:),4,[]), 'num_pts', 110);
    chords = PT.renormI(cross(s(:,1:2:end), s(:,2:2:end)));
    n = chords(1:2,:);
    n = n ./ vecnorm(n, 2, 1);
    n = n .* sign(dot(n, s(1:2,1:2:end) - c(1:2,:)));
    p = c(1:2,:) + c(3,:) .* n;  % middle points
    c = [c; p; n]; % [x_center; y_center; radius; x_oncircle; y_oncircle; x_normal; y_normal;]

    draw(xd, Gapp, c, arcs, Gvpc, 'manhattan')
end

% omega_ = cam.K * cam.K';
% vx = rand(1) * 10;
% v = [vx * gt.l(2); - gt.l(3) - vx * gt.l(1); gt.l(2)];
% u = cross(omega_ \ v, gt.l);
% dot(u, gt.l)
% dot(v, gt.l)
% dot(u, omega_ \ v)

function draw(x, Gapp, c, arcs, Gvpc, figname)
    % figure
    f = figure('visible','off');
    axis ij equal off
    xlim([0 1000]);
    ylim([0 1000]);
    cmap = lines(max(Gapp));
    for k = 1:max(Gapp), LAF.draw(gca, x(:,Gapp==k), 'Color', cmap(k,:), 'LineWidth', 1.5); end
    CIRCLE.draw(gca,c(1:3,Gvpc==1), 'Color', 'm', 'LineWidth', 1.75, 'LineStyle', ':');
    CIRCLE.draw(gca,c(1:3,Gvpc==2), 'Color', 'g', 'LineWidth', 1.75, 'LineStyle', ':');
    ARC.draw(gca,arcs(:,Gvpc==1),'Color', 'm', 'LineWidth',1.5);
    ARC.draw(gca,arcs(:,Gvpc==2),'Color', 'g', 'LineWidth',1.5);
    saveas(f, ['~/' figname '.png']);
end