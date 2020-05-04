function rd = project_bc(ru, theta, proj_params)
    k = [proj_params(1:2) proj_params(5:end)];
    if isempty(ru)
        % TODO: Add NaNs where abs(theta) > 90-eps
        ru = tan(theta);
    end
    ru2 = ru.^2;
    pows = (1:numel(k)) .* (k~=0);
    rd = ru .* (1 + (ru2' .^ pows) * k')';
end