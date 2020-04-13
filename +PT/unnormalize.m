function x = unnormalize(x, K, k)
    if nargin < 3
        k = 3;
    end
    m = size(x, 1);
    x = reshape(K * reshape(x, k, []), m, []);
end