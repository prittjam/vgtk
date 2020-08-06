function x = normalize(x, K, k)
    % K -- camera matrix
    
    if nargin < 3
        k = 3;
    end
    if iscell(x)
        m = size(x{1}, 1);
        x = cellfun(@(x0) reshape(K \ reshape(x0, k, []), m, []), x, 'UniformOutput', false);
    else
        m = size(x, 1);
        x = reshape(K \ reshape(x, k, []), m, []);
    end
end