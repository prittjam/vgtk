function res = intersection(c1, c2)
    % c -- [cx; cy; R]

    x1 = c1(1,:);
    y1 = c1(2,:);
    R1 = c1(3,:);
    x2 = c2(1,:);
    y2 = c2(2,:);
    R2 = c2(3,:);

    dx = (x2 - x1) ./ R2;
    dy = (y2 - y1) ./ R2;
    dr = sqrt(dx.^2 + dy.^2);

    d = R1 ./ R2;

    a = atan2(dy, dx);

    b1 = a - acos((d.^2 - 1 - dr.^2)./2./dr);
    b2 = a + acos((d.^2 - 1 - dr.^2)./2./dr);

    res = [[R2 .* cos(b1) + x2; R2 .* sin(b1) + y2]...
           [R2 .* cos(b2) + x2; R2 .* sin(b2) + y2]]

    % CIRCLE.draw(c1);
    % CIRCLE.draw(c2);
    % GRID.draw(res(1:2,:));
    % GRID.draw(res(3:4,:));
    % axis equal
end