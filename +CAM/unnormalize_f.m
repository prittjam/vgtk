function f = unnormalize_f(f, A)
    sc = A(1,1);
    f = f / sc;
end