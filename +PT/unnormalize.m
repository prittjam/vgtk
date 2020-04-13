function x = unnormalize(x, A, k)
    if nargin < 3
        k = 3;
    end
    m = size(x, 1);
    x = reshape(A \ reshape(x, k, []), m, []);
end