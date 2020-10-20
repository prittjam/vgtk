function xp = mtimesx(M,x,k)
    if nargin < 3
        k = 3;
    end
    m = size(x,1);
    l = size(M,1);
    n = m/k;
    xp = zeros([l*n,size(x,2)]);
    for k2 = 1:n
        k3 = k2*k;
        xp((k2-1)*l+1:k2*l,:) = multiprod(M,reshape(x((k2-1)*k+1:k2*k,:),k,1,[]));
    end
end