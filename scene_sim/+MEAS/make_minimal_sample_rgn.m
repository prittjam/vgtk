function [X, x] = make_minimal_sample_rgn(n, wplane, hplane, cam, direction)
    %
    % Args:
    %   n
    %   wplane
    %   hplane
    %   cam
    %   direction
    %
    % Returns:
    %   X -- scene plane points in RP2
    %   x -- image points in RP2

    assert(n > 1)
    if nargin == 4
        direction = 'rand';
    end
    X = CSPOND_SET.rgns_t(n, wplane, hplane, 'direction', direction);
    project_fn = str2func(['RP2.' cam.proj_fn]);
    x = project_fn(RP2.mtimesx(cam.P, X), cam.K, cam.proj_params);
end