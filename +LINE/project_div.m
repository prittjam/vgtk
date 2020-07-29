function [ld, obj] = project_div(l, K, proj_params)
    % proj_params -- [q cx cy]
    proj_params0 = zeros(1,3);
    proj_params0(1:size(proj_params,2)) = proj_params;
    
    % Radial distortion
    q = proj_params0(1);

    % Shift by distortion center
    C = [1 0 proj_params0(2); 0 1 proj_params0(3); 0 0 1];

    if abs(q) > 0
        if ~isempty(K)
            l = LINE.normalize(l, K);
        end

        l = C' * l;
        
        xc0 = - l(1,:) ./ l(3,:) ./ 2 ./ q;
        yc0 = - l(2,:) ./ l(3,:) ./ 2 ./ q;
        R = sqrt( (l(1,:).^2 + l(2,:).^2) ./...
                  (l(3,:).^2) ./ 4 ./ (q.^2) - 1 ./ q);
        c0 = C*RP2.homogenize([xc0;yc0]);
        ld = [c0(1:2,:); R];
        
        if ~isempty(K)
            ld = CIRCLE.unnormalize(ld, K);
        end
        obj = 'circle';
    else
        ld = l;
        obj = 'line';
    end
end