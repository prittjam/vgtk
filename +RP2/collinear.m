function res = collinear(x, y)
    if (size(x,1) == 2)
        x = [x; zeros(1,size(x,2))];
    end
    if (size(y,1) == 2)
        y = [y; zeros(1,size(y,2))];
    end
    assert(size(x,1) == size(y,1));
    if size(x,2) == 1
        x = repmat(x,1,size(y,2));
    elseif size(y,2) == 1     
        y = repmat(y,1,size(x,2));
    else
        assert(size(x,2) == size(y,2));
    end
    m = size(x,1);
    res = PT.collinear_3D(reshape(x,3,[]), reshape(y,3,[]));
    res = reshape(res,m/3,[]);
end