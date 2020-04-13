function cam = make_lens(cam, q, A)
    cam.q_norm = q;
    cam.A = A;
    cam.q = CAM.unnormalize_div(cam.q_norm, cam.A);
end