function xu = backproject_sc(xd, K, q)
    xu = PT.backproject_rat(xd, K, q, 3);
end