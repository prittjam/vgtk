function v = backproject_sc(u, K, proj_params)
    % proj_params -- [a0 a2 a3 a4]

    a = proj_params;
    if any(abs(a)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        v = K \ v;

        a0 = a(1);
        a = a(2:end);
        r = vecnorm(v(1:2,:),2,1);
        pows = (2:numel(a)+1) .* (a~=0);
        dv = (a0 + (r'.^(pows)) * a')';
        v(1:2,:) = bsxfun(@rdivide, v(1:2,:), dv); 
        
        v = K * v;     
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end