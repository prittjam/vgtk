function x = project_perspective(X, f, proj_params)
    if nargin < 2
        f = 1;
    end
    r0 = vecnorm(X(1:2,:),2,1);
    phi = atan(r0, X(3,:));
    r = f * tan(phi); 
    x = r .* X(1:2,:) ./ r0;
end