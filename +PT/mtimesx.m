function xp = mtimesx(M,x,k)
    if nargin < 3
        k = 3;
    end
    xp = zeros(size(x));
    m = size(x,1);
    for k2 = 1:k:m
        xp(k2:k2+k-1,:) = multiprod(M,reshape(x(k2:k2+k-1,:),k,1,[]));
    end
end