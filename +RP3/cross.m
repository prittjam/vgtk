function l = cross(X, Y)
    %
    % Args:
    %   X -- 4xK, first points in homogeneous coordinates
    %   Y -- 4xK, second points in homogeneous coordinates
    %
    % Returns:
    %   l -- 6xK, lines in homogeneous/Plucker/Grassmann coordinates
    
    l = [Y(4,:) .* X(1:3,:) - X(4,:) .* Y(1:3,:);...
         cross(X(1:3,:), Y(1:3,:))];

    infidx = abs(l(6,:))<1e-11;
    l(:,~infidx) = l(:,~infidx)./l(6,~infidx);
end
