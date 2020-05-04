function r = project_equidistance(theta, f, proj_params)
    if nargin<2 || isempty(f)
        f = 1;
    end
    r = f * theta;
end