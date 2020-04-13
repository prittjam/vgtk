function v = distort_kb(u, k, A)
    if any(k) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        
        v = A \ v;
        r = vecnorm(v(1:2,:),2,1);
        theta = atan(r);
        theta2 = theta.^2;
        pows = (1:numel(k)) .* (k~=0);
        theta_d = theta .* (1 + (theta2' .^ pows) * k')';

        ind = find(r > 1e-8);
        inv_r = ones(1,size(r,2));
        inv_r(ind) = 1.0 ./ r(ind);
        cdist = ones(1,size(r,2));
        cdist(ind) = theta_d(ind) .* inv_r(ind);

        v = [v(1:2,:) .* cdist; ones(1,size(v,2))];
        v = A * v;
        
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end