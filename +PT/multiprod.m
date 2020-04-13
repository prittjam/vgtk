function y = multiprod(T, x, k)
    if nargin < 3
        k = 3;
    end
    m = size(x, 1);
    y = reshape(multiprod(T, reshape(x, k, [])), m, []);
end