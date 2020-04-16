function dist_params = unnormalize_sc(dist_params, A)
    sc = A(1,1);
    a = dist_params{1} * min(A(1:2,3));
    a(2) = a(2) / (sc^2);
    a(3) = a(3) / (sc^3);
    a(4) = a(4) / (sc^4);
    dist_params{1} = a;
end
