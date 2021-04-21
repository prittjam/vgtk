function v = project_bc(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [k1...kN t1...tN] in mm
    %
    % Returns:
    %   v -- 3xN
    
    if numel(proj_params)/2 < 4
        k = proj_params(1:numel(proj_params));
        t = zeros(1,numel(proj_params));
    else
        k = proj_params(1:numel(proj_params)/2);
        t = proj_params(numel(proj_params)/2+1:end);
    end

    if any(abs(proj_params)) > 0
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end
        v = v./v(3,:);
        r2 = v(1,:).^2+v(2,:).^2;
        pows = 1:size(k,2);
        v(1:2,:) = (1 + k * r2.^(pows')) ./ ...
                   (1 + t * r2.^(pows')) .* v(1:2,:);
        
        if ~isempty(K)
            v = K * v;
        end
    end
end