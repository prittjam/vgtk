function v = distort_bc(u, K, dist_coeffs)
    if any(abs(dist_coeffs)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end        
        v = K \ v;

        k = dist_coeffs([1:2, 5:end]);
        p = dist_coeffs(3:4);
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