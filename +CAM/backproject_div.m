function v = backproject_div(u, K, proj_params)
    % proj_params -- q

    q = proj_params(1);
    if abs(q) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end

        v(3,:) = 1+q*(v(1,:).^2+v(2,:).^2);
        
        if ~isempty(K)
            v(1:2,:) = bsxfun(@rdivide,v(1:2,:),v(3,:)); 
            v(3,:) = 1;
            v = K * v;
        end
    else
        v = u;
    end
end
