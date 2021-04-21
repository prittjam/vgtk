function v = backproject_rat(v, K, proj_params)
    % Args:
    %   v -- 3xN
    %   K -- 3x3
    %   proj_params -- [mu1...muk lambda1...lambdak] in mm
    %
    % Returns:
    %   v -- 3xN
    
    cx = 0;
    cy = 0;
    % mu = proj_params(1:numel(proj_params)/2);
    % lambda = proj_params(numel(proj_params)/2+1:end);
    lambda = proj_params;
    mu = zeros(size(lambda));

    if any(abs(proj_params)) > 0
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end
        C = [1 0 cx; 0 1 cy; 0 0 1];
        v = C \ v;

        r2 = v(1,:).^2+v(2,:).^2;
        pows = 1:size(lambda,2);
        v(3,:) = (1 + lambda * r2.^(pows')) ./ ...
                 (1 + mu * r2.^(pows'));
        
        v = C * v;
        if ~isempty(K)
            v(1:2,:) = bsxfun(@rdivide,v(1:2,:),v(3,:)); 
            v(3,:) = 1;
            v = K * v;
        end
    end
end