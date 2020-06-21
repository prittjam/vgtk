function [X, x] = make_minimal_sample_linept(n, wplane, hplane, cam, direction)
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

    assert(n > 1)
    if nargin < 4 || isempty(direction)
        direction = 'rand';
    end
    [L, S] = CSPOND_SET.lines(2, wplane, hplane, 'direction', direction);
    X = S(:,1:2);
    t = 0.1 + rand(1,n-2) * 0.8;
    X = [X t.*X(:,1) + (1 - t).*X(:,2)];

    project_fn = str2func(['RP2.' cam.proj_fn]);
    x = project_fn(RP2.mtimesx(cam.P, X), cam.K, cam.proj_params);

    % % close all
    % subplot(1,2,1)
    % GRID.draw(X)
    % axis equal xy
    % subplot(1,2,2)
    % GRID.draw(x)
    % axis equal xy
end