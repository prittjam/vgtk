function [p, n] = get_midpoint(circ, s1, s2)
    if nargin<3
        s = s1;
        if size(s,1) == 4
            s = RP2.homogenize(s);
        end
        s1 = s(1:3,:);
        s2 = s(4:6,:);
    elseif size(s1,1) == 2
        s1 = RP2.homogenize(s1);
        s2 = RP2.homogenize(s2);
    end

    chords = PT.renormI(cross(s1, s2));
    n = chords(1:2,:);
    n = n ./ vecnorm(n, 2, 1);
    n = n .* sign(dot(n, s1(1:2,:) - circ(1:2,:)));
    p = circ(1:2,:) + circ(3,:) .* n;
end