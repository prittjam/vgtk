function v = backproject_div(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [q cx cy] in mm
    %
    % Returns:
    %   v -- 3xN
    
    proj_params0 = zeros(1,3);
    proj_params0(1:size(proj_params,2)) = proj_params;
    
    % Radial distortion
    q = proj_params0(1);

    % Shift by distortion center
    C = [1 0 proj_params0(2); 0 1 proj_params0(3); 0 0 1];

    if abs(q) > 0
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end

        v = C \ v;

        v(3,:) = 1+q*(v(1,:).^2+v(2,:).^2);
        
        v = C * v;

        if ~isempty(K)
            v(1:2,:) = bsxfun(@rdivide,v(1:2,:),v(3,:)); 
            v(3,:) = 1;
            v = K * v;
        end
    end
end