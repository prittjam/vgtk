function line = move(line,displacement)
% line is a 2x2 matrix
% rows equal to points, columns to coordinates
catheti = abs(line(1,:) - line(2,:));
h = hypot(catheti(1),catheti(2));
movex = catheti(1)/h;
movey = catheti(2)/h;
line(:,1) = line(:,1) + displacement*movey;
line(:,2) = line(:,2) + displacement*movex;