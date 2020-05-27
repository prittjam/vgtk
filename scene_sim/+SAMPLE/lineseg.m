function [X, x, phi] = lineseg(n, wplane, hplane, cam, noise)
    % phi -- [relangle(vp1,vp2), ..., relangle(vp1,vpN)];
    X = CSPOND_SET.point_ct(n, wplane, hplane, 'regular', true);
    project_x = str2func(['RP2.' cam.proj_fn]);
    x = project_x(RP2.mtimesx(cam.P, X), cam.K, cam.proj_params);
    % x_norm = RP2.normalize(x, cam.K);
    phi = ct_to_phi(X);
    % keyboard
    if nargin == 5 && ~isempty(noise) && ~(noise==0)
        x = RP2.add_noise(x, noise);
    end
end