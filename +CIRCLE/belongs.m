function res = belongs(x, circ)
    if size(x,1)==3
        x = PT.renormI(x);
    end
    cx = circ(1,:);
    cy = circ(2,:);
    r = circ(3,:);
    res = abs( (((x(1,:) - cx) ./ r).^2 +...
                ((x(2,:) - cy) ./ r).^2) - 1 ) < 1e-12;