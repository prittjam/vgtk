function [arcs, circles] = unnormalize(arcs, K, circles)
    arcs = cellfun(@(x) K * x, arcs, 'UniformOutput', false);
    if nargout == 2
        assert(nargin == 3);
        circles = CIRCLE.unnormalize(circles, K);
    end
end
