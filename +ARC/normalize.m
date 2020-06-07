function [arcs, circles] = normalize(arcs, K, circles)
    arcs = cellfun(@(x) K \ x, arcs, 'UniformOutput', false);
    if nargout == 2
        assert(nargin == 3);
        circles = CIRCLE.normalize(circles, K);
    end
end
