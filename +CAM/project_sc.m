function v = project_sc(v, K, proj_params)
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
            v = CAM.project_div(v, [], a(2));
        else

            R = vecnorm(v(1:2,:),2,1);
            Z = v(3,:);

            nonzero = find(R~=0);

            for k=nonzero
                rts2 = roots([a(4:-1:2) -Z(k)/R(k) a(1)]);
                % sD = sqrt(9*a(3)^2 - 32*a(2)*a(4));
                % if sD > 0
                %     rmax = [(-3*a(3)-sD)/(8*a(4)) (-3*a(3)+sD)/(8*a(4))];
                %     rmax = rmax(rmax>0);
                %     d2rmax = 2*a(2) + 6*a(3)*rmax + 12*a(4)*rmax.^2;
                %     rmax = rmax(d2rmax > 0);
                %     if isempty(rmax)
                %         rmax = inf;
                %     else
                %         rmax = min(rmax);
                %     end
                % else
                %     rmax = inf;
                % end
                rts2 = real(rts2(abs(imag(rts2))<1e-7));
                rts2 = rts2(rts2 > 0);
                % rts2 = rts2(rts2 < rmax);
                if numel(rts2) < 1
                    r(k) = NaN;
                else    
                    r(k) = min(rts2);
                end
            end
            v(1:2,nonzero) = v(1:2,nonzero) .* r(:,nonzero) ./ R(:,nonzero);
            v(3,:) = 1;
        end

        v = C * v;
        
        if ~isempty(K)
            v = K * v;
        end
    end
end