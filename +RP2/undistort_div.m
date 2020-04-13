function xu = undistort_div(xd, K, q)
    xu = PT.undistort_div(xd, K, q, 3);
end