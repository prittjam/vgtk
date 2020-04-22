function v = backproject_kb(u, K, dist_params)
    % dist_params -- [k1 k2 k3 k4]
    
    if any(abs(dist_params)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        v = K \ v;

        r = vecnorm(v(1:2,:),2,1);
        k1 = dist_params(1);
        k2 = dist_params(2);
        k3 = dist_params(3);
        k4 = dist_params(4);
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

        % theta_d = vecnorm(v(1:2,:),2,1);
        % theta_d = min(max(-pi/2.0, theta_d), pi/2.0);
        % sc = ones(1,size(theta_d,2));
        % continue_flag = theta_d > 1e-15;
        % theta = theta_d;
        % for k1=1:10
        %     ind = find(continue_flag);
        %     theta_ = theta(ind);
        %     theta_d_ = theta_d(ind);
        %     k0_theta2 = dist_params(1) .* theta_.^2;
        %     k1_theta4 = dist_params(2) .* theta_.^4;
        %     k2_theta6 = dist_params(3) .* theta_.^6;
        %     k3_theta8 = dist_params(4) .* theta_.^8;
        %     theta_fix(ind) = (theta_ .* (1 + k0_theta2 +...
        %                             k1_theta4 + k2_theta6 +...
        %                             k3_theta8) - theta_d_) ./...
        %                 (1 + 3 .* k0_theta2 + 5 .* k1_theta4 +...
        %                         7 .* k2_theta6 + 9 .* k3_theta8);
        %     theta = theta - theta_fix;
        %     continue_flag = (abs(theta_fix) > 1e-15);
        %     if (sum(continue_flag) == 0)
        %         break;
        %     end
        %     sc = tan(theta) ./ theta_d;
        % end
        % v(1:2,:) = v(1:2,:) .* sc;

        v = K * v;
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end