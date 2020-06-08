function draw_lines(lgrid, distorted, varargin)
    if nargin < 2 || isempty(distorted)
        distorted = false;
    end
    if distorted
        CIRCLE.draw(lgrid, varargin{:});
    else
        LINE.draw(gca, lgrid, varargin{:});
    end
end