function r = project_stereographic(theta, f)
    if nargin<2 || isempty(f)
        f = 1;
    end
    r = 2 * f * tan(theta/2);
end