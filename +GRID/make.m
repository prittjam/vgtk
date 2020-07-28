function x = make(w, h, gridsize)
    t = linspace(-0.5, 0.5, gridsize);
    [a, b] = meshgrid(t, t);
    X = transpose([a(:) b(:) ones(numel(a), 1)]);
    A = [[w 0; 0 h] [0 0]'; 0 0 1];
    x = A * X;
end