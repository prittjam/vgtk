function [gt, xd, Gapp, Gvpx, c, s, arcs, Gvpc, X, L, S, uvw] = manhattan(varargin)
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
        cc = cfg.cc;
    end    
    
    wplane = 10;
    hplane = 10;

    f = 5 * rand(1) + 3;
    ccd_mm = 4.8;
    cam = CAM.make_ccd(f, ccd_mm, cfg.nx, cfg.ny);
    A = inv(CAM.make_fitz_normalization(cam.cc));
    cam = CAM.make_lens(cam, cfg.q, 'div');
    gt = CAM.make_viewpoint(cam);

    U = [rand(2,1); 0];  
    V = [U(2); -U(1); 0];

    % Lines
    [L, S, ~, Gvpc] = CSPOND_SET.lines(randi([cfg.n_lines_min, cfg.n_lines_max]),...
                                                    wplane, hplane, 'direction', U(1:2),...
                                                    'regular', cfg.regular);
    [L1, S1, ~, Gvpc1] = CSPOND_SET.lines(randi([2,cfg.n_lines_max]),...
                                                       wplane, hplane, 'direction', V(1:2),...
                                                       'regular', cfg.regular);
    L = [L L1];
    S = [S S1];
    Gvpc = [Gvpc Gvpc1+max(Gvpc)];

    % LAFs
    [X, ~, Gapp] = CSPOND_SET.rgns_t(randi([cfg.n_lafs_min, cfg.n_lafs_max]),...
                                           wplane, hplane, 'direction', V(1:2),...
                                           'regular', cfg.regular);
    Gvpx = ones(1,size(X,2)) * 2;
    if cfg.n_laf_groups_max > 1
        n_lafG = randi(cfg.n_laf_groups_max-1);
        for i=1:n_lafG
            if (rand() < 0.5); d = U(1:2); l = 1; else; d = V(1:2); l = 2; end
            [X1, ~, Gapp1] = CSPOND_SET.rgns_t(randi([2,cfg.n_lafs_max]),...
                                            wplane, hplane, 'direction', d,...
                                            'regular', cfg.regular);
            X = [X X1];
            Gapp = [Gapp Gapp1+max(Gapp)];
            Gvpx = [Gvpx ones(1,size(X1,2)) * l];
        end
    end
    
    u = PT.renormI(gt.P * U);
    v = PT.renormI(gt.P * V);
    W = cross(gt.K \ u, gt.K \ v);
    w = PT.renormI(gt.K * W);
    uvw =[u v w];

    x = RP2.renormI(blkdiag(gt.P, gt.P, gt.P) * X);
    xd = CAM.distort_div(reshape(x,3,[]), gt.A, gt.q_norm);
    xd = reshape(xd, 9, []); 

    c = LINE.distort_div(gt.P' \ L, gt.A, gt.q_norm);
    s = CAM.distort_div(PT.renormI(gt.P * S), gt.A, gt.q_norm);
    arcs = ARC.sample(c, reshape(s(1:2,:),4,[]), 'num_pts', 110);
    chords = PT.renormI(cross(s(:,1:2:end), s(:,2:2:end)));
    n = chords(1:2,:);
    n = n ./ vecnorm(n, 2, 1);
    n = n .* sign(dot(n, s(1:2,1:2:end) - c(1:2,:)));
    p = c(1:2,:) + c(3,:) .* n;  % middle points
    c = [c; p; n]; % [x_center; y_center; radius; x_oncircle; y_oncircle; x_normal; y_normal;]

    % SCENE.draw_clusters(xd, Gapp, c, arcs, Gvpc)
end

% omega_ = gt.K * gt.K';
% vx = rand(1) * 10;
% v = [vx * gt.l(2); - gt.l(3) - vx * gt.l(1); gt.l(2)];
% u = cross(omega_ \ v, gt.l);
% dot(u, gt.l)
% dot(v, gt.l)
% dot(u, omega_ \ v)

