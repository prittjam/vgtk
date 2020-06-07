function [X, x, phi] = make_minimal_sample_lineseg(n, wplane, hplane, cam, direction)
    %
    % Args:
    %   n
    %   wplane
    %   hplane
    %   cam
    %
    % Returns:
    %   X -- scene plane points in RP2
    %   x -- image points in RP2
    %   phi -- relative angles between line segments:
    %            [relangle(vp1,vp2), ..., relangle(vp1,vpN)];

    assert(n > 1)
    if nargin == 4
        direction = 'rand';
    end
    X = CSPOND_SET.point_csponds(n, wplane, hplane,...
                                'regular', true,...
                                'direction', direction);
    project_x = str2func(['RP2.' cam.proj_fn]);
    x = project_x(RP2.mtimesx(cam.P, X), cam.K, cam.proj_params);
    phi = ct_to_phi(X);
end