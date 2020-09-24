function Rt_world = board_to_world(Rt, Rt0)
    R = Rt(:,1:3);
    t = Rt(:,4);
    R0 = Rt0(:,1:3);
    t0 = Rt0(:,4);
    Rt_world(:,1:3) = R*R0';
    Rt_world(:,4) = t - R*R0'*t0;
end