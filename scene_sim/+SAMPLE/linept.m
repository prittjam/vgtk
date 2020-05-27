function [X, x, phi] = linept(n, wplane, hplane, cam, noise)
    X = CSPOND_SET.point_line(n, wplane, hplane, 'regular', true);
    project_x = str2func(['RP2.' cam.proj_fn]);
    x = project_x(RP2.mtimesx(cam.P, X), cam.K, cam.proj_params);
    if nargin == 5 && ~isempty(noise) && ~(noise==0)
        x = RP2.add_noise(x, noise);
    end
    phi = [];
end