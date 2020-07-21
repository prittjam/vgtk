function v = project_div(u, K, proj_params)
    % proj_params -- [q, c]

    % Radial distortion
    q = proj_params(1);
    
    % Shift by distortion center
    c = proj_params([2 3]);

    if abs(q) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        if ~isempty(K)
            v = K \ PT.renormI(v);
            c = K \ [c'; 1];
        end

        C = [1 0 c(1); 0 1 c(2); 0 0 1];
        v = C \ v;

        R = vecnorm(v(1:2,:),2,1);
        Z = v(3,:);
        r = max((Z+sqrt(Z.^2-4.*q.*R.^2))./(2.*q.*R),...
                       (Z-sqrt(Z.^2-4.*q.*R.^2))./(2.*q.*R));
        v(1:2,:) = v(1:2,:) .* r ./ R;
        v(3,:) = 1;
        
        v = C * v;

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