function r = project_orthogonal(theta, f)
    if nargin<2 || isempty(f)
        f = 1;
    end
    r = f * sin(theta);
end