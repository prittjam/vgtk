function draw_cts(cts, distorted, varargin)
    if distorted
        ARC.draw(cts, varargin{:});
    else
        LINESEG.draw(gca, cts, varargin{:});
    end
end