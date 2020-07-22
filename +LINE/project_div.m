function [ld, obj] = project_div(l, K, q, cc)
    if nargin < 4
        cc = [0 0]';
    end

    C = [1 0 cc(1); ...
         0 1 cc(2); ...
         0 0    1];            
    if abs(q) > 0
        if ~isempty(K)
            l = LINE.normalize(l, K);
        end

        l = C' * l;
        
        xc0 = - l(1,:) ./ l(3,:) ./ 2 ./ q;
        yc0 = - l(2,:) ./ l(3,:) ./ 2 ./ q;
        R = sqrt( (l(1,:).^2 + l(2,:).^2) ./...
                  (l(3,:).^2) ./ 4 ./ (q.^2) - 1 ./ q);
        c0 = C*RP2.homogenize([xc0;yc0]);
        ld = [c0(1:2,:); R];
        
        if ~isempty(K)
            ld = CIRCLE.unnormalize(ld, K);
        end
        obj = 'circle';
    else
        ld = l;
        obj = 'line';
    end
end