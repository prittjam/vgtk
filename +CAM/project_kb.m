function v = project_kb(u, K, proj_params)
    % proj_params -- [k1 k2 k3 k4]

    if any(abs(proj_params)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        if ~isempty(K)
            v = K \ PT.renormI(v);
        end

        r = vecnorm(v(1:2,:),2,1);
        theta = atan2(r, v(3,:));
        theta2 = theta.^2;
        pows = (1:numel(proj_params)) .* (proj_params~=0);
        rd = theta .* (1 + (theta2' .^ pows) * proj_params')';

        ind = find(r > 1e-8);
        inv_r = ones(1, size(r,2));
        inv_r(ind) = 1.0 ./ r(ind);
        cdist = ones(1,size(r,2));
        cdist(ind) = rd(ind) .* inv_r(ind);
        v = [v(1:2,:) .* cdist; ones(1,size(v,2))];

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


% function v = project_kb(u, K, proj_params, varargin)
%     % proj_params -- [k1 k2 k3 k4]
%     cfg = struct('is_world_point', false);
%     cfg = cmp_argparse(cfg, varargin{:});
    
%     if any(abs(proj_params)) > 0

%         m = size(u,1);
%         if (m == 2)
%             v = PT.homogenize(u);
%         else
%             v = u;
%         end
        
%         if ~cfg.is_world_point
%             v = K \ v;
%         end

%         r = vecnorm(v(1:2,:),2,1);
%         theta = atan2(v(3,:),r);
%         theta2 = theta.^2;
%         pows = (1:numel(proj_params)) .* (proj_params~=0);
%         theta_d = theta .* (1 + (theta2' .^ pows) * proj_params')';

%         ind = find(r > 1e-8);
%         inv_r = ones(1, size(r,2));
%         inv_r(ind) = 1.0 ./ r(ind);
%         cdist = ones(1,size(r,2));
%         cdist(ind) = theta_d(ind) .* inv_r(ind);
%         v = [v(1:2,:) .* cdist; ones(1,size(v,2))];
        
%         v = K * v;     
%         if (m == 2)
%             v = v(1:2,:);
%         end
%     else
%         v = u;
%     end
% end