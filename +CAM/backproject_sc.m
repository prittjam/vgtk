function v = backproject_sc(u, K, proj_params)
    % proj_params -- [a0 a2 a3 a4 cx cy]
    
    proj_params0 = [1 zeros(1,5)];
    proj_params0(1:size(proj_params,2)) = proj_params;
    
    % Radial distortion
    a = proj_params0(1:4);

    % Shift by distortion center
    C = [1 0 proj_params0(5); 0 1 proj_params0(6); 0 0 1];

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

        v = C \ v;

        if (a(1) == 1 & a(3) == 0 & a(4) == 0)
            v = CAM.backproject_div(v, [], a(2));
        else

            a0 = a(1);
            a = a(2:end);
            r = vecnorm(v(1:2,:),2,1);
            pows = (2:numel(a)+1) .* (a~=0);
            v(3,:) = (a0 + (r'.^(pows)) * a')';        
        
        end
        
        v = C * v;

        if ~isempty(K)
            v(1:2,:) = bsxfun(@rdivide,v(1:2,:),v(3,:)); 
            v(3,:) = 1;
            v = K * v;
        end
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end