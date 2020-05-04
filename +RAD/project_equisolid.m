function r = project_equisolid(theta, f, proj_params)
    if nargin<2 || isempty(f)
        f = 1;
    end
    r = 2 * f * sin(theta/2);
end