function draw_linesegs(linesegs, distorted, varargin)
    if distorted
        ARC.draw(gca, linesegs, varargin{:});
    else
        LINESEG.draw(gca, linesegs, varargin{:});
    end
end