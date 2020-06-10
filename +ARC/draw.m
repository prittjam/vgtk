function draw(arcs, varargin)
    % arcs -- {3 x arc_length} x num_arcs
    colormap(hsv(numel(arcs)))
    cmap = colormap;
    for k=1:numel(arcs)
        arc = arcs{k};
        hold on
        if any(strcmpi('color',varargin))
            plot(arc(1,:), arc(2,:), varargin{:});
        else
            plot(arc(1,:), arc(2,:), "Color", cmap(k,:), varargin{:});
        end
        GRID.draw(arc(:,round((size(arc,2)+1)/2)), varargin{:})
    end
    hold off;