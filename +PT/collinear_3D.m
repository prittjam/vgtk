function res = collinear_3D(x, y)
    assert(size(x,1) == size(y,1));
    assert(size(x,1) == 3);
    res = all(abs(cross(x,y))<1e-9, 1);
end