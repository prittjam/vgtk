function [c, s, arcs, l, su] = image_planar_lines(L, S, gt)
    % Images coplanar lines with division model of radial distortion 

    l = gt.P' \ L;
    su = PT.renormI(gt.P * S);
    c = LINE.distort_div(l, gt.A, gt.q_norm);
    s = CAM.distort_div(su, gt.A, gt.q_norm);
    arcs = ARC.sample(c, reshape(s(1:2,:),4,[]), 'num_pts', 110);
    chords = PT.renormI(cross(s(:,1:2:end), s(:,2:2:end)));
    n = chords(1:2,:);
    n = n ./ vecnorm(n, 2, 1);
    n = n .* sign(dot(n, s(1:2,1:2:end) - c(1:2,:)));
    p = c(1:2,:) + c(3,:) .* n;  % middle points
    c = [c; p; n]; % [x_center; y_center; radius; x_oncircle; y_oncircle; x_normal; y_normal;]
end