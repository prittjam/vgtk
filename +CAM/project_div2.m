function x = project_div2(u, K, q, cc, Kp)
    if isempty(cc) || nargin < 4
        cc = [0 0];        
    end
    
    if nargin < 5
        Kp = eye(3);
    end
    
    C = eye(3);
    C(1:2,3) = cc(1:2);    

    x = C \ Kp \ u;

    keyboard;
    if q ~= 0
        R = vecnorm(x(1:2,:),2,1);
        Z = x(3,:);
        r = max((Z+sqrt(Z.^2-4.*q.*R.^2))./(2.*q.*R),...
                       (Z-sqrt(Z.^2-4.*q.*R.^2))./(2.*q.*R));
        x(1:2,:) = x(1:2,:) .* r ./ R;
        x(3,:) = 1;
    end
    
    x = K*C*x;