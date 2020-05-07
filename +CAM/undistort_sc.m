function v = undistort_sc(u, K, dist_params)
% dist_params -- [a0 a2 a3 a4]

    a = dist_params;
    if any(abs(a)) > 0
        m = size(u,1);
        if (m == 2)
            v = PT.homogenize(u);
        else
            v = u;
        end
        v = K \ v;

        a0 = a(1);
        a = a(2:end);
        r = vecnorm(v(1:2,:),2,1);
        pows = (2:numel(a)+1) .* (a~=0);
        dv = (a0 + (r'.^(pows)) * a')';
        v(1:2,:) = bsxfun(@rdivide, v(1:2,:), dv); 
        
        v = K * v;     
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end

% function v = undistort_sc(u, K, dist_params)
%     % dist_params -- cell
%         % {1}: [a0 a2 a3 a4]  % MappingCoefficients
%         % {2}: [cx cy]        % DistortionCenter
%         % {3}: [s1 s2; s3 s4] % Stretchmatrix
%         % {4}: [h w]          % ImageSize

%     a = dist_params{1};
%     if any(abs(a)) > 0
%         m = size(u,1);
%         dist_params = CAM.unnormalize_sc(dist_params, K);
%         a = dist_params{1};
%         dc = dist_params{2};
%         imgsize = dist_params{4};
%         v = undistortFisheyePoints(u(1:2,:)',...
%                 fisheyeIntrinsics(a, imgsize, dc))';
%         if (m == 3)
%             v = PT.homogenize(v);
%         end
%     else
%         v = u;
%     end
% end