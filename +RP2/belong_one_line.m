function res = belong_one_line(x, y, z)
    if (size(x,1) == 2)
        x = [x; ones(1,size(x,2))];
    end
    if (size(y,1) == 2)
        y = [y; ones(1,size(y,2))];
    end
    if (size(z,1) == 2)
        z = [z; ones(1,size(y,2))];
    end
    assert(size(x,1) == size(y,1) & size(x,1) == size(z,1));
    assert(size(x,2) == size(y,2) & size(x,2) == size(z,2));
    for k1=1:size(x,2)
        res(k1) = (abs(det([x(:,k1) y(:,k1) z(:,k1)])) < 1e-9);
    end
end