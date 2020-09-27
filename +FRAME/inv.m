function Rt2 = compose(Rt1)
    % Args:
    %   Rt1 -- from point A to point B: B = R1*A + t1 
    %
    % Returns:
    %   Rt2 -- from point B to point A: A = R2*B + t2
    %
    % B = R1*A + t1
    % -> A = R1'*B - R1'*t1

    R1 = Rt1(:,1:3);
    t1 = Rt1(:,4);
    Rt2(:,1:3) = R1';
    Rt2(:,4) = - R1'*t1;
end