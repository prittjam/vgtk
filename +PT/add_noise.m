function x = add_noise(x, sgma, k)
    if nargin < 4
        k = 3;
    end
    m = size(x, 1);
    x = reshape(GRID.add_noise(reshape(x, k, []), sgma), m, []);
end