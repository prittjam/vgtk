function [ld, obj] = project_div(l, K, q)
    if abs(q) > 0
        if ~isempty(K)
            l = LINE.normalize(l, K);
        end

        xc0 = - l(1,:) ./ l(3,:) ./ 2 ./ q;
        yc0 = - l(2,:) ./ l(3,:) ./ 2 ./ q;
        R = sqrt( (l(1,:).^2 + l(2,:).^2) ./...
                  (l(3,:).^2) ./ 4 ./ (q.^2) - 1 ./ q);
        ld = [xc0; yc0; R];

        if ~isempty(K)
            ld = CIRCLE.unnormalize(ld, K);
        end
        obj = 'circle';
    else
        ld = l;
        obj = 'line';
    end
end