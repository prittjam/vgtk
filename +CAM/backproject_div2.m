function x = backproject_div2(x,K,q,cc,Kp)
    if q == 0
        return
    end
    
    if isempty(cc) || nargin < 4
        cc = [0 0]';
    end
    
    if nargin < 5 
        Kp = eye(3);
    end

    C = eye(3);
    C(1:2,3) = cc(1:2);
    x = C \ (K \ RP2.renormI(x));
    r2 = vecnorm(x(1:2,:)).^2;
    x(3,:) = 1+q*r2;
    x = Kp*C*x;