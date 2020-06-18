function [X, x, phi] = make_minimal_sample_lineseg(n, wplane, hplane, cam, direction, direction2)
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
    if nargin < 5 || isempty(direction)
        direction = 'rand';
    end
    if nargin < 6 || isempty(direction2)
        % % In general
        % direction2 = 'rand';
        
        % For dstortion center
        direction2 = [0.5; 0.5];
    end
    X = CSPOND_SET.point_csponds(n, wplane, hplane,...
                                'regular', true,...
                                'direction', direction,...
                                'direction2', direction2);
    project_x = str2func(['RP2.' cam.proj_fn]);
    x = project_x(RP2.mtimesx(cam.P, X), cam.K, cam.proj_params);
    phi = ct_to_phi(X);
end