function rd = project_kb(ru, theta, proj_params)
    k = proj_params;
    if isempty(theta)
        theta = atan(ru);
    end
    theta2 = theta.^2;
    pows = (1:numel(k)) .* (k~=0);
    rd = theta .* (1 + (theta2' .^ pows) * k')';
end