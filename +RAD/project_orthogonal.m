function r = project_orthogonal(theta, f, proj_params)
    if nargin<2 || isempty(f)
        f = 1;
    end
    r = f * sin(theta);
end