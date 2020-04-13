function f = unnormalize_f_div(f, A)
    sc = A(1,1);
    f = f / sc;
end