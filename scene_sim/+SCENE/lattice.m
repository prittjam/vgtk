function [gt1, gt2, X, L, xd, c, arcs,...
          Gapp, Gvpx, Gvlx, Gvpc,...
          cspond, Gappnck, Gvpnck, Gvlnck,...
          uvw] = lattice(varargin)

    cfg = struct('nx', 1000, ...
                'ny', 1000,...
                'cc', [], ...
                'q', -4,...
                'outliers', true);
    cfg = cmp_argparse(cfg,varargin{:});

    if isempty(cfg.cc)
        cc = [cfg.nx/2+0.5; ...
              cfg.ny/2+0.5];
    else
        cc = cfg.cc;
    end    

    wplane = 10;
    hplane = 10;

    f_mm = 5*rand(1)+3;
    ccd_mm = 4.8;
    cam = CAM.make_ccd(f_mm, ccd_mm, cfg.nx, cfg.ny);
    A = inv(CAM.make_fitz_normalization(cam.cc));
    cam = CAM.make_lens(cam, cfg.q, A);
    gt1 = CAM.make_viewpoint(cam);
    
    % First Plane
    u = PT.renormI(gt1.P34 * [1; 0; 0; 0]);
    v = PT.renormI(gt1.P34 * [0; 1; 0; 0]);
    w = PT.renormI(gt1.P34 * [0; 0; 1; 0]);

    % Lattice 1
    [X, ~, Gapp] = CSPOND_SET.rgns_t(6, wplane, hplane,...
                                          'direction', [1; 0],...
                                          'direction2', [0; 1],...
                                          'regular', true);
    
    xd = CAM.image_planar_pts(X, gt1);
    Gvpx = num2cell(ones(1,size(Gapp,2)).*[1; 2], 1);
    Gvlx = ones(1,size(Gapp,2)) * 1;


    % SCENE.draw_LAFs(X, Gapp);
    % SCENE.draw_LAFs(RP2.renormI(RP2.multiprod(gt1.P, X)), Gapp);
    % SCENE.draw_LAFs(xd, Gapp);

    % Lines
    [L, S, ~, ~] = CSPOND_SET.lines(6, wplane, hplane,...
                                                'direction', [1; 0],...
                                                'regular', true);
    Gvpc = ones(1,size(L,2)).* 1;
    [c, ~, arcs] = image_lines(L, S, gt1.P, gt1.cc, gt1.q);
    % SCENE.draw_clusters(xd, Gapp, c, arcs,  Gvpc);

    [L1, S1, ~, ~] = CSPOND_SET.lines(6, wplane, hplane,...
                                                'direction', [0; 1],...
                                                'regular', true);
    Gvpc1 = ones(1,size(L1,2)).* 2;
    Gvpc = [Gvpc ones(1,size(L1,2)).* 2];
    [c1, ~, arcs1] = image_lines(L1, S1, gt1.P, gt1.cc, gt1.q);
    L = [L L1];
    S = [S S1];
    c = [c c1];
    arcs = [arcs, arcs1];
    % SCENE.draw_clusters(xd, Gapp, c, arcs, Gvpc)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Second Plane
    A = [[0 1 0]' [0 0 1]' [1 0 0]']; % Changes to {V, W, U} basis
    % perm2 = [[0 0 1]' [1 0 0]' [0 1 0]']; % Changes to {V, W, U} basis
    % [P_2,~,P34_2,R_2,t_2] = PLANE.make_viewpoint2(gt1.R * A, gt1.c, cam); 
    % gt2 = PLANE.make_Rt_gt(1, P_2, q, cam.cc, 0, P34_2, R_2, t_2);
    % A = [[0 0 -1]; [0 1 0]; [1 0 0]];
    gt2 = CAM.make_viewpoint(cam, 'R', gt1.R * A, 'c', - inv(gt1.R) * gt1.c);

    % Lattice 2
    [X2, ~, Gapp2] = CSPOND_SET.rgns_t(6, wplane, hplane,...
                                            'direction', [1; 0],...
                                            'direction2', [0; 1],...
                                            'regular', true);
    xd2 = CAM.image_planar_pts(X2, gt2);
    Gapp = [Gapp Gapp2+max(Gapp)];
    Gvpx = [Gvpx num2cell(ones(1,size(Gapp2,2)).*[2; 3], 1)];
    Gvlx = [Gvlx ones(1,size(Gapp2,2)) * 2];

    % SCENE.draw_LAFs(X2, Gapp2);
    % SCENE.draw_LAFs(xd2, Gapp2);
    % SCENE.draw_LAFs(reshape(PT.renormI(inv(P_2) * reshape(xd2,3,[])),9,[]), Gapp2);

    % SCENE.draw_LAFs(X2, Gapp2);
    % SCENE.draw_LAFs(RP2.renormI(RP2.multiprod(gt2.P, X2)), Gapp2);
    % SCENE.draw_LAFs(xd2, Gapp2);
    % return

    X = [X X2];
    xd = [xd xd2];
    % SCENE.draw_LAFs(xd, Gapp);

    % Lines
    [L2, S2, ~, ~] = CSPOND_SET.lines(8, wplane, hplane,...
                                                 'direction', [0; 1],...
                                                 'regular', true);
    Gvpc = [Gvpc ones(1,size(L2,2)).* 3];
    [c2, ~, arcs2] = image_lines(L2, S2, gt2.P, cam.cc, gt2.q);
    L = [L L2];
    S = [S S2];
    c = [c c2];
    arcs = [arcs, arcs2];

    uvw = cam.K * gt1.R;
    % uvwp = PT.renormI(RP2.rd_div(RP2.renormI(uvw),cc,q));
    % figure
    % axis equal
    % % LINE.draw(gca,L2);
    % LAF.draw(gca,xd);
    % CIRCLE.draw(c, 'Color', 'g', 'LineWidth', 1.75, 'LineStyle', ':');
    % ARC.draw(arcs,'Color', 'm', 'LineWidth',1.5);
    % scatter(uvwp(1,:),uvwp(2,:))
    % keyboard
    % SCENE.draw_clusters(xd, Gapp, c, arcs, Gvpc)

    if cfg.outliers
        % Outliers 1
        [Xout1, ~, GappOut1] = CSPOND_SET.rgns_t(6, wplane, hplane,'regular', true);
        Gapp = [Gapp GappOut1+max(Gapp)];
        Gvpx = [Gvpx num2cell(ones(1,size(GappOut1,2)).* nan, 1)];
        Gvlx = [Gvlx ones(1,size(GappOut1,2)) * 1];
        xout1 = CAM.image_planar_pts(Xout1, gt1);
        X = [X Xout1];
        xd = [xd xout1];
        % SCENE.draw_LAFs(X, Gapp);
        % SCENE.draw_LAFs(xd, Gapp);
        
        % Outliers 2
        [Xout2, ~, GappOut2] = CSPOND_SET.rgns_t(6, wplane, hplane,'regular', true);
        Gapp = [Gapp GappOut2+max(Gapp)];
        Gvpx = [Gvpx num2cell(ones(1,size(GappOut2,2)).* nan, 1)];
        Gvlx = [Gvlx ones(1,size(GappOut2,2)) * 2];
        xout2 = CAM.image_planar_pts(Xout2, gt1);
        X = [X Xout2];
        xd = [xd xout2];
        % SCENE.draw_LAFs(Xout2, GappOut2);
        % SCENE.draw_LAFs(xd, Gapp);

        % Line Outliers 1
        [LOut1, SOut1, ~, ~] = CSPOND_SET.lines(6, wplane, hplane, 'regular', true);
        Gvpc = [Gvpc ones(1,size(LOut1,2)).* nan];
        [cOut1, ~, arcsOut1] = image_lines(LOut1, SOut1, gt1.P, cam.cc, gt1.q);
        L = [L LOut1];
        S = [S SOut1];
        c = [c cOut1];
        arcs = [arcs, arcsOut1];

        % Line Outliers 2
        [LOut2, SOut2, ~, ~] = CSPOND_SET.lines(6, wplane, hplane,...
                                                            'regular', true);
        Gvpc = [Gvpc ones(1,size(LOut2,2)).* nan];
        [cOut2, ~, arcsOut2] = image_lines(LOut2, SOut2, gt2.P, cam.cc, gt2.q);
        L = [L LOut2];
        S = [S SOut2];
        c = [c cOut2];
        arcs = [arcs, arcsOut2];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Cspondences
    [cspond, Gvpnck, Gvlnck, Gappnck] = get_lattice_labeling(1,2);
    [cspond2, Gvpnck2, Gvlnck2, Gappnck2] = get_lattice_labeling(2,3);
    [cspondOut1, GvpnckOut1, GvlnckOut1, GappnckOut1] = get_outliers_labeling(6);
    [cspondOut2, GvpnckOut2, GvlnckOut2, GappnckOut2] = get_outliers_labeling(6);
    cspond = [cspond; max(cspond,[],'all')+cspond2];
    if cfg.outliers
        cspond = [cspond; max(cspond,[],'all')+cspondOut1];
        cspond = [cspond; max(cspond,[],'all')+cspondOut2];
    end
    Gvpnck = [Gvpnck Gvpnck2];
    Gvlnck = [Gvlnck Gvlnck2];
    Gappnck = [Gappnck Gappnck2+max(Gappnck)];
    if cfg.outliers
        Gvpnck = [Gvpnck GvpnckOut1 GvpnckOut2];
        Gvlnck = [Gvlnck GvlnckOut1 GvlnckOut2];
        Gappnck = [Gappnck GappnckOut1+max(Gappnck)];
        Gappnck = [Gappnck GappnckOut2+max(Gappnck)];
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % % Check
    % Imaged scene
    % SCENE.draw_clusters(xd, Gapp, c, arcs, Gvpc);

    % % % % Rectify the first plane
    % Hr = cam.K * gt1.R' * inv(cam.K);
    % xu = RP2.ru_div(xd, gt1.cc, gt1.q);
    % xr = PT.renormI(blkdiag(Hr,Hr,Hr) * xu);
    % SCENE.draw_LAFs(xr, Gapp);

    % % % Rectify the second plane
    % Hr = cam.K * gt2.R' * inv(cam.K);
    % xu = RP2.ru_div(xd, gt2.cc, gt2.q);
    % xr = PT.renormI(blkdiag(Hr,Hr,Hr) * xu);
    % SCENE.draw_LAFs(xr, Gapp);

    % % Rectify the second plane using gt1.R
    % % perm = [[0 1 0]' [0 0 1]' [1 0 0]'];
    % % R1_permuted = perm' * gt1.R;
    % % OR
    % R1_permuted = [gt1.R(:,2) gt1.R(:,3) gt1.R(:,1)];
    % Hr = cam.K * R1_permuted' * inv(cam.K);
    % xr = PT.renormI(blkdiag(Hr,Hr,Hr) * xu);
    % SCENE.draw_LAFs(xr, Gapp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% U V (R1 R2) --> vl1
% V W (R2 R3) --> vl2
% U W (R1 R3) --> vl3

% U --> vl1, vl3
% V --> vl1, vl2
% W --> vl2, vl3

function [cspond, Gvpnck, Gvlnck, Gappnck] = get_lattice_labeling(VP1, VP2)
    VL = [nan 1 3; 1 nan 2; 3 2 nan];

    cspond1 = repmat(nchoosek(1:6,2),1,1,6) +...
    repmat(reshape(repmat([0:6:30],2,1),1,2,[]),nchoosek(6,2),1);
    cspond1 = reshape(permute(cspond1,[1,3,2]),[],2);
    Gvpnck1 = ones(1,size(cspond1,1)) * VP1;

    cspond2 = repmat(nchoosek(1:6:36,2),1,1,6) +...
        repmat(reshape(repmat([0:5],2,1),1,2,[]),nchoosek(6,2),1);
    cspond2 = reshape(permute(cspond2,[1,3,2]),[],2);
    Gvpnck2 = ones(1,size(cspond1,1)) * VP2;

    cspond = [cspond1; cspond2];
    Gvpnck = [Gvpnck1 Gvpnck2];
    Gvlnck = ones(1,size(cspond,1)) * VL(VP1, VP2);

    Gappnck = ones(1,size(Gvpnck,2));
end

function [cspond, Gvpnck, Gvlnck, Gappnck] = get_outliers_labeling(N)
    cspond = nchoosek(1:N,2);
    Gvpnck = ones(1,size(cspond,1)) * nan;
    Gvlnck = ones(1,size(cspond,1)) * nan;
    Gappnck = ones(1,size(Gvpnck,2));
end

function [c, s, arcs] = image_lines(L, S, P, cc, q)
    A = inv(CAM.make_fitz_normalization(cc));
    q_norm = CAM.normalize_div(q, A);
    c = LINE.distort_div(P' \ L, A, q_norm);

    s = CAM.distort_div(PT.renormI(P * S), A, q_norm);
    arcs = ARC.sample(c, reshape(s(1:2,:),4,[]), 'num_pts', 110);
    chords = PT.renormI(cross(s(:,1:2:end), s(:,2:2:end)));
    n = chords(1:2,:);
    n = n ./ vecnorm(n, 2, 1);
    n = n .* sign(dot(n, s(1:2,1:2:end) - c(1:2,:)));
    p = c(1:2,:) + c(3,:) .* n;  % middle points
    c = [c; p; n]; % [x_center; y_center; radius; x_oncircle; y_oncircle; x_normal; y_normal;]
end