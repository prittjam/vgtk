function v = project_sc(u, K, proj_params)
    % proj_params -- [a0 a2 a3 a4 cx cy]
    proj_params0 = zeros(1,6);
    proj_params0(1:size(proj_params,2)) = proj_params;
    a = proj_params0(1:4);
    c = [proj_params0(5:6)'; 0];
    if any(abs(a)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end

        v = v - c;

        R = vecnorm(v(1:2,:),2,1);
        Z = v(3,:);

        % % c(1) + c(2)*x + c(3)*x^2 + c(4)*x^3 + c(5)*x^4 = 0
        % coef = [r'.*a(1) -ones(size(r')) r'.*a(2:end)];
        % rts = solve_quartic(coef);
        % kv = rts(:,1)';

        for k=1:numel(R)
            rts2 = roots([a(4)*R(k), a(3)*R(k), a(2)*R(k), -Z(k), a(1)*R(k)]);
            sD = sqrt(9*a(3)^2 - 32*a(2)*a(4));
            if sD > 0
                rmax = [(-3*a(3)-sD)/(8*a(4)) (-3*a(3)+sD)/(8*a(4))];
                rmax = rmax(rmax>0);
                d2rmax = 2*a(2) + 6*a(3)*rmax + 12*a(4)*rmax.^2;
                rmax = rmax(d2rmax > 0);
                if isempty(rmax)
                    rmax = inf;
                else
                    rmax = min(rmax);
                end
            else
                rmax = inf;
            end
            rts2 = real(rts2(abs(imag(rts2))<1e-5));
            rts2 = rts2(rts2 > 0);
            rts2 = rts2(rts2 < rmax);
            if numel(rts2) < 1
                r(k) = NaN;
            else    
                r(k) = max(rts2);
            end
            % keyboard
            % [~,idx]=min(real(R(k)-rts2));
            % r(k) = rts2(idx);
        end
        v(1:2,:) = v(1:2,:) .* r ./ R;
        v(3,:) = 1;

        v = v + c;
        
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