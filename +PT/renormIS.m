function y = renormIS(x,k)
    if nargin < 2
        k = 3;
    end
    m = size(x,1);
    x = reshape(x,k,[]);
    y = reshape(x./abs(x(end,:)),m,[]);
end