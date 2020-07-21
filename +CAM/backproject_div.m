function v = backproject_div(u, K, proj_params)
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

        v(3,:) = 1+q*(v(1,:).^2+v(2,:).^2);
        
        v = C * v;

        if ~isempty(K)
            v(1:2,:) = bsxfun(@rdivide,v(1:2,:),v(3,:)); 
            v(3,:) = 1;
            v = K * v;
        end
    else
        v = u;
    end
end
