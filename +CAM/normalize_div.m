function q = normalize_div(q, K)
    sc = K(1,1);
    q = q * (sc^2);
end