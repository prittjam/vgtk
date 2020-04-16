function v = distort_bc(u, K, dist_params)
    % dist_params -- [k1 k2 p1 p2 k3 k4 k5 ...]

    if any(abs(dist_params)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end        
        v = K \ v;

        k = dist_params([1:2, 5:end]);
        p = dist_params(3:4);
        r2 = sum(v(1:2,:).^2,1);
        pows = (1:numel(k)) .* (k~=0);
        kv = (1 + (r2'.^(pows)) * k')';
        dv(1,:) = 2 .* p(1) .* v(1,:) .* v(2,:) + p(2) .* (r2 + 2 .* v(1,:).^2);
        dv(2,:) = 2 .* p(2) .* v(1,:) .* v(2,:) + p(1) .* (r2 + 2 .* v(2,:).^2);
        v(1:2,:) = bsxfun(@times, v(1:2,:), kv) + dv;    
        
        v = K * v;
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end