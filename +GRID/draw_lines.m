function draw_lines(lgrid, distorted, varargin)
    if distorted
        CIRCLE.draw(gca, lgrid, varargin{:});
    else
        LINE.draw(gca, lgrid, varargin{:});
    end
end