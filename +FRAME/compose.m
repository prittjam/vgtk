function Rt = compose(Rt1, Rt2)
    % Args:
    %   Rt1 -- from point A to point B: B = R1*A + t1 
    %   Rt2 -- from point B to point C: C = R2*B + t2
    %
    % Returns:
    %   Rt -- from point A to point C: C = R*A + t
    %
    % C = R2*B + t2 = R2*(R1*A + t1) + t2 = R2*R1*A + R2*t1 + t2

    R1 = Rt1(:,1:3);
    t1 = Rt1(:,4);
    R2 = Rt2(:,1:3);
    t2 = Rt2(:,4);
    Rt(:,1:3) = R2*R1;
    Rt(:,4) =  R2*t1 + t2;
end