%%%%%%% WIP
function [c, c_norm] = arc(n, wplane, hplane, cam)
    % L = 
    c = CAM.image_planar_lines(L, cam);
    c_norm = CIRCLE.normalize(c, cam.K);
end