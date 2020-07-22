function x = backproject_div2(x,K,q,cc,Kp)
    if q == 0
        return
    end
    
    if isempty(cc) || nargin < 4
        cc = [0 0]';
    end
    

    C = eye(3);
    C(1:2,3) = cc(1:2);
    x = C \ (K \ RP2.renormI(x));
    x(3,:) = 1+q*(sum(x(1:2,:).^2));

    x = C*x;
    if nargin == 5
        x = Kp*RP2.renormI(x);
    end