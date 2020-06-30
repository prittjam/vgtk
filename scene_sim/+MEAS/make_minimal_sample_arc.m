function [L, arcs, circles] = make_minimal_sample_arc(N, wplane, hplane, cam, direction, varargin)
    %
    % Args:
    %   N
    %   wplane
    %   hplane
    %   cam
    %
    % Returns:
    %   L -- scene plane points in RP2
    %   arcs -- image points in RP2
    %   circles -- relative angles between line segments:
    %            [relangle(vp1,vp2), ..., relangle(vp1,vpN)];

    cfg.num_pts = 110;
    cfg = cmp_argparse(cfg, varargin{:});

    assert(N > 1)
    if nargin < 4 || isempty(direction)
        direction = 'rand';
    end
    [L, S] = CSPOND_SET.lines(N, wplane, hplane,...
                             'direction', direction, 'regular', true);
    l = cam.P' \ L;
    s = RP2.mtimesx(cam.P, reshape(S,6,[]));
    %%%%%%%%%%%%%%%% WORKAROUND FOR WILDENAUER'S SOLVER
    if N==5
        l = l(:,1:3);
        s = s(:,1:3);
        [L1, S1] = CSPOND_SET.lines(2, wplane, hplane,...
                             'direction', [0 1], 'regular', true);
        l1 = cam.P' \ L1;
        s1 = RP2.mtimesx(cam.P, reshape(S1,6,[]));
        l = [l l1(:,1)];
        s = [s s1(:,1)];

        u = PT.renormI(cam.K * (cam.R * eye(3)));
        L = [u(2,3); 0; 100];
        L(2,1) = -L(3,1) * u(3,3)/u(2,3) - u(1,3);

        % Segments
        N = 1;
        v = [-wplane/2 wplane/2 -hplane/2 hplane/2];
        top = repmat(cross([v(1) v(3) 1]', [v(2) v(3) 1]'), 1, N);
        bottom = repmat(cross([v(1) v(4) 1]', [v(2) v(4) 1]'), 1, N);
        left = repmat(cross([v(1) v(3) 1]', [v(1) v(4) 1]'), 1, N);
        right = repmat(cross([v(2) v(3) 1]', [v(2) v(4) 1]'), 1, N);
        pts = [LINE.intersect(L, top);...
            LINE.intersect(L, bottom);...
            LINE.intersect(L, left);...
            LINE.intersect(L, right)];
        ia = [repmat((pts(1,:) > v(1)) & (pts(1,:) < v(2)), 2, 1);...
            repmat((pts(3,:) > v(1)) & (pts(3,:) < v(2)), 2, 1);...
            repmat((pts(6,:) > v(3)) & (pts(6,:) < v(4)), 2, 1);...
            repmat((pts(8,:) > v(3)) & (pts(8,:) < v(4)), 2, 1)];
        edges = reshape(pts(ia(:)),2,[]);
        edges = reshape(edges, 4, N);
        k0 = rand(1, N) * 0.3;
        k1 = rand(1, N) * 0.3 + 0.7;
        s0 = edges(1:2,:) + k0 .* (edges(3:4,:) - edges(1:2,:));
        s1 = edges(1:2,:) + k1 .* (edges(3:4,:) - edges(1:2,:));
        S = [PT.homogenize(s0); PT.homogenize(s1)];
        s2 = reshape(S, 6, []);
        s2(4:6) = s2(4:6) + 5 * (RP2.renormI(u(:,3))- s2(4:6));
        l2 = L;

        l = [l l2];
        s = [s s2];

        assert(all(abs(dot(l(:,1:3),u(:,[1 1 1])))<1e-9))
        assert(all(abs(dot(l(:,4),u(:,2)))<1e-9))
        assert(all(abs(dot(l(:,5),u(:,3)))<1e-9))

        % close all
        % LINE.draw2(l)
        % keyboard

        % l0 = LINE.normalize(l, cam.K);
        % u0 = cam.K \ u;
    end
    %%%%%%%%%%%%%%%%

    project_fn = str2func(['LINE.' cam.proj_fn]);
    circles = project_fn(l, cam.K, cam.proj_params);
    project_fn = str2func(['RP2.' cam.proj_fn]);
    s = project_fn(s, cam.K, cam.proj_params);
    [p, n] = ARC.get_midpoint(circles, s);
    circles = [circles; p; n];
    arcs = ARC.sample(circles, s, 'num_pts', cfg.num_pts);

    % %%%%%%%%%%%%%%%% DEBUG
    % close all
    % CIRCLE.draw(circles,'Color',[1 1 1 2 3])
    % ARC.draw(arcs,'LineWidth',2,'Color',[1 1 1 2 3])
    % GRID.draw(s)
    % axis equal
    % keyboard
    % %%%%%%%%%%%%%%%%
end