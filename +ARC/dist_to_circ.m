function errs = dist_to_circ(arcs, c)
    % distance from arc points to a circle
    %   arcs -- N arcs {[x11...x1K1],...,[xN1...xNKN]}
    %   c -- N circles
    errs = [];
    for k=1:size(c,2)
        errs = [errs CIRCLE.orthodist(arcs{k}, c(:,k), 'mean', false)];
    end
end