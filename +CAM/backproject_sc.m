function v = backproject_sc(u, K, proj_params)
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

        a0 = a(1);
        a = a(2:end);
        r = vecnorm(v(1:2,:),2,1);
        pows = (2:numel(a)+1) .* (a~=0);
        v(3,:) = (a0 + (r'.^(pows)) * a')';
        
        v = v + c;

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