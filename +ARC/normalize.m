function arcs = normalize(arcs, K)
    arcs = cellfun(@(x) K \ x, arcs, 'UniformOutput', false);
end
