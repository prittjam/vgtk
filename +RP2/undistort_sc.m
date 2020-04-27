function xu = undistort_sc(xd, K, q)
    xu = PT.undistort_sc(xd, K, q, 3);
end