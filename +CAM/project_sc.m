function v = project_sc(u, K, proj_params)
    % proj_params -- [a0 a2 a3 a4]

    a = proj_params;
    if any(abs(a)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = PT.renormI(u);
        end
        if ~isempty(K)
            v = K \ v;
        end

        r = vecnorm(v(1:2,:),2,1);

        % % c(1) + c(2)*x + c(3)*x^2 + c(4)*x^3 + c(5)*x^4 = 0
        % coef = [r'.*a(1) -ones(size(r')) r'.*a(2:end)];
        % rts = solve_quartic(coef);
        % kv = rts(:,1)';

        for k=1:numel(r)
            rts2 = roots([a(4)*r(k), a(3)*r(k), a(2)*r(k), -1, a(1)*r(k)]);
            if numel(rts2) == 4
                kv(k) = rts2(4);
            elseif numel(rts2) == 3
                keyboard
                kv(k) = rts2(3);
            elseif numel(rts2) == 2
                kv(k) = rts2(rts2>0);
            else
                kv(k) = rts2(1);
            end
            % METRICS.relerr(rts(k), kv(k));
        end
        v(1:2,:) = v(1:2,:) .* kv ./ r;
        
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