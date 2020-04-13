function v = distort_poly(u, k, A)
    if any(k) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        
        v = A \ v;
        r2 = sum(v(1:2,:).^2,1);

        pows = (1:numel(k)) .* (k~=0);
        dv = (1 + (r2'.^(pows)) * k')';
        v(1:2,:)  = bsxfun(@times, v(1:2,:), dv); 
        v = A * v;
        
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end