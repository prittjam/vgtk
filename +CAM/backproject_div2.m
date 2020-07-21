function v = backproject_div(u, K, proj_params, K_new)
    % proj_params -- [q, c]

    % Radial distortion
    q = proj_params(1);
    
    % Shift by distortion center
    if numel(proj_params) == 3
        c = proj_params([2 3]);
    else
        if ~isempty(K)
            c = [0; 0];
        else
            c = K(1:2,3);
        end
    end
    
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

        if nargin==4 && ~isempty(K_new)
            v(1:2,:) = bsxfun(@rdivide,v(1:2,:),v(3,:)); 
            v(3,:) = 1;
            v = K_new * v;
        end
    else
        v = u;
    end
end
