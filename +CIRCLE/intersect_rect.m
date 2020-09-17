function pts = intersect_rect(circ, rect)
    % Finds intersection points of circles and rectangle
    % Args:
    %   circ -- [3,N] circles
    %   rect -- [2,4] rectangle (TODO: [2,4] -> [1,4])

    x0 = circ(1,:);
    y0 = circ(2,:);

    x = [min(rect(1,:)); max(rect(1,:))];
    y = [min(rect(2,:)); max(rect(2,:))];

    D = circ(3,:).^2 - (x - x0).^2;
    idx = find(D>=0);
    y1 = ones(size(D)) * NaN;
    y2 = ones(size(D)) * NaN;
    y0 = kron(y0,ones(size(D,1),1));
    y1(idx) = y0(idx) + sqrt(D(idx));
    y2(idx) = y0(idx) - sqrt(D(idx));
    x1 = kron(x,ones(1,3));
    x2 = kron(x,ones(1,3));

    D = circ(3,:).^2 - (y - y0).^2;
    idx = find(D>=0);
    x3 = ones(size(D)) * NaN;
    x4 = ones(size(D)) * NaN;
    x0 = kron(x0,ones(size(D,1),1));
    x3(idx) = x0(idx) + sqrt(D(idx));
    x4(idx) = x0(idx) - sqrt(D(idx));
    y3 = kron(y,ones(1,3));
    y4 = kron(y,ones(1,3));

    x = [x1;x2;x3;x4];
    y = [y1;y2;y3;y4];

    for k=1:3
        pts{k} = [x(:,k)'; y(:,k)'; ones(1,size(x,1))];
        pts{k} = pts{k}(:,~any(isnan(pts{k})));
    end
end