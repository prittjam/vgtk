function circ = normalize(circ, K)
    % circ -- circle in the image (hom.) coordinates
    %         2xN -- [cx...; cy...] or
    %         3xN -- [cx...; cy...; R] or
    %         7xN -- [cx...; cy...; R; px...; py...; nx...; ny...]
    % K -- camera matrix

    c = K \ PT.homogenize(circ(1:2,:));
    circ(1:2,:) = c(1:2,:);
    if size(circ,1) > 2
        circ(3,:) = circ(3,:) ./ K(1,1);
        if size(circ,1) > 3
            p = K \ PT.homogenize(circ(4:5,:));
            circ(4:5,:) = p(1:2,:);
        end
    end
end
