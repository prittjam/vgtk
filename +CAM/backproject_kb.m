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
            v = K \ PT.renormI(v);
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
                theta(k) = NaN;
            else
                theta(k) = min(rts);
            end
        end
        v(3, :) = 0;
        ind = abs(theta - pi/2) > 1e-8;
        v(3, ind) = 1 ./ tan(theta(ind));
        
        ind = (r > 1e-8);
        v(1:2,ind) = v(1:2,ind) ./ r(ind);
        
        if ~isempty(K)
            ru = ones(size(r)) * NaN;
            valid_ind = theta < (pi/2 - 1e-5);
            ru(valid_ind) = tan(theta(valid_ind));
            v(1:2,ind) = v(1:2,ind) .* ru(ind);
            v(3,ind) = 1;
            v(:,ind) = K * v(:,ind);
            v(:,~ind) = NaN;
        end
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end