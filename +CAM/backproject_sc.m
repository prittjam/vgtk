function v = backproject_sc(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [a2 a3 a4 cx cy] in mm
    %
    % Returns:
    %   v -- 3xN

    proj_params0 = zeros(1,5);
    proj_params0(1:size(proj_params,2)) = proj_params;
    
    % Radial distortion
    a = [1 proj_params0(1:3)];

    % Shift by distortion center
    C = [1 0 proj_params0(4); 0 1 proj_params0(5); 0 0 1];

    if any(abs(a)) > 0
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
    end
end