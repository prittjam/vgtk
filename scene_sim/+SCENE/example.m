w_plane = 10;
h_plane = 10;

w_img = 1000;
h_img = 1000;

f = 5*rand(1)+3;
ccd_mm = 4.8;
q = -7;
cam = CAM.make_ccd(f, ccd_mm, w_img, h_img);
A = inv(CAM.make_fitz_normalization(cam.cc));
cam = CAM.make_lens(cam, q, A);
gt = CAM.make_viewpoint(cam);

[L, S, ~, ~] = CSPOND_SET.lines(7, w_plane, h_plane);
% close all; figure; axis equal; LINESEG.draw(gca,S);
c = LINE.distort_div(gt.P' \ L, gt.A, gt.q_norm);

% close all; figure; axis equal; CIRCLE.draw(c);
arcs = {};
for k=1:5
    arcs1 = ARC.sample(c);
    arcs = {arcs{:} arcs1{:}};
    % ARC.draw(arcs1, 'linewidth', 2)
end

keyboard