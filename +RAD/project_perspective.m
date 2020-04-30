function r = project_perspective(theta, f)
    if nargin<2 || isempty(f)
        f = 1;
    end
    r = f * tan(theta);
end