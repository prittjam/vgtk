function arcs = unnormalize(arcs, K)
    arcs = cellfun(@(x) K * x, arcs, 'UniformOutput', false);
end
