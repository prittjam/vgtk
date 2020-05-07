function f = normalize_f(f, K)
    sc = K(1,1);
    f = f * sc;
end