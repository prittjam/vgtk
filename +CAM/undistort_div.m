function v = undistort_div(u, K, q)
    if abs(q) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        v = K \ v;

        dv = 1+q*(v(1,:).^2+v(2,:).^2);
        v(1:2,:)  = bsxfun(@rdivide,v(1:2,:),dv); 
        
        v = K * v;
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end
