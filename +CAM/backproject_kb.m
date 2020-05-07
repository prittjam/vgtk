function v = backproject_kb(u, K, proj_params)
    % proj_params -- [k1 k2 k3 k4]
    
    if any(abs(proj_params)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        if ~isempty(K)
            v = K \ v;
        end

        r = vecnorm(v(1:2,:),2,1);
        k1 = proj_params(1);
        k2 = proj_params(2);
        k3 = proj_params(3);
        k4 = proj_params(4);
        for k=1:numel(r)
            rts = roots([k4 0 k3 0 k2 0 k1 0 1 -r(k)]);
            rts = real(rts(abs(imag(rts))<1e-8));
            rts = rts(rts >= 0);
            if numel(rts) == 0
                throw()
            else
                ru(k) = tan(min(rts));
            end
        end
        ind = find(r > 1e-8);
        inv_r = ones(1, size(r,2));
        inv_r(ind) = 1.0 ./ r(ind);
        cdist = ones(1,size(r,2));
        cdist(ind) = ru(ind) .* inv_r(ind);
        v = [v(1:2,:) .* cdist; ones(1,size(v,2))];

        if ~isempty(K)
            v = K * v;
        end
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end