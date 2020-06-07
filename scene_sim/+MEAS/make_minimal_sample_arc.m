function [L, arcs, circles] = make_minimal_sample_arc(n, wplane, hplane, cam, direction)
    %
    % Args:
    %   n
    %   wplane
    %   hplane
    %   cam
    %
    % Returns:
    %   L -- scene plane points in RP2
    %   arcs -- image points in RP2
    %   circles -- relative angles between line segments:
    %            [relangle(vp1,vp2), ..., relangle(vp1,vpN)];

    cfg.num_arc_pts = 110;

    assert(n > 1)
    if nargin == 4
        direction = 'rand';
    end
    [L, S] = CSPOND_SET.lines(n, wplane, hplane,...
                             'direction', direction, 'regular', true);
    S = reshape(S,6,[]);
    project_fn = str2func(['LINE.' cam.proj_fn]);
    circles = project_fn(cam.P' \ L, cam.K, cam.proj_params);
    project_fn = str2func(['RP2.' cam.proj_fn]);
    s = project_fn(RP2.mtimesx(cam.P, S), cam.K, cam.proj_params);
    % s = CIRCLE.project(reshape([circles; circles], 3, []), s);
    [p, n] = ARC.get_midpoint(circles, s);
    circles = [circles; p; n];

    arcs = ARC.sample(circles, s, 'num_pts', cfg.num_arc_pts);
end