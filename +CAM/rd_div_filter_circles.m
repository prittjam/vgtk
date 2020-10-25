function valid = rd_div_filter_circles(c, nx, ny, outlierT, dc)
    if nargin<4
        outlierT = 1e9;
    end

    flag_radius = c(3,:) > 0.2 * min(nx, ny);
    if nargin < 5 | (nargin == 5 & dc)
        flag_dc = (nx/2+0.5 - c(1,:)).^2 +...
                  (ny/2+0.5 - c(2,:)).^2 < 1.5 * c(3,:).^2;
    else
        flag_dc = 1;
    end

    flag_cc = all(abs(c(1:2,:)) < outlierT);

    valid = flag_radius & flag_dc & flag_cc;
end