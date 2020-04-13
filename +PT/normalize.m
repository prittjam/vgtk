function x = normalize(x, K, k)
    % K -- camera matrix
    
    if nargin < 3
        k = 3;
    end
    m = size(x, 1);
    x = reshape(K \ reshape(x, k, []), m, []);
end