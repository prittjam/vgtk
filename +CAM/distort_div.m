function v = distort_div(u, K, dist_params)
    % dist_params -- q

    q = dist_params(1);
    if abs(q) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        v = K \ v;

        xu = v(1,:);
        yu = v(2,:);
        v(1,:) = xu/2./(q*yu.^2+xu.^2*q).*(1-sqrt(1-4*q*yu.^2-4*xu.^2*q));
        v(2,:) = yu/2./(q*yu.^2+xu.^2*q).*(1-sqrt(1-4*q*yu.^2-4*xu.^2*q));
        
        v = K * v;
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end