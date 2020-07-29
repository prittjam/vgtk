function L = backproject_div(circ, K, proj_params, p)
    % circ -- circle in the image (hom.) coordinates
    %         3xN -- [cx...; cy...; R] or
    %         4xN -- [px...; py...; nx...; ny...]
    % K -- camera matrix
    % proj_params -- [q, cx, cy], where q -- division model parameter,
    %                                   [cx, cy] -- distortion center
    % [p -- 2xN -- [px...; py...]]

    proj_params0 = zeros(1,3);
    proj_params0(1:size(proj_params,2)) = proj_params;
    
    % Radial distortion
    q = proj_params0(1);

    % Shift by distortion center
    C = [1 0 proj_params0(2); 0 1 proj_params0(3); 0 0 1];

    if size(circ,1)==3
        assert(nargin==4)
        assert(size(circ,2)==size(p,2))
        if size(p,1)==3
            p = PT.renormI(p);
        end
        n = (p(1:2,:) - circ(1:2,:)) ./ circ(3,:);
        assert(all(abs(vecnorm(n,2,1)-1) < 1e-13))
        p = K \ p;
    else
        p = K \ PT.homogenize(circ(1:2,:));
        n = circ(3:4,:);
    end

    px = p(1,:);
    py = p(2,:);
    nx = n(1,:);
    ny = n(2,:);
    Lx = nx + q * (nx .* px.^2 - nx .* py.^2 +...
                  2 * ny .* px .* py);
    Ly = ny + q * (ny .* py.^2 - ny .* px.^2 +...
                  2 * nx .* px .* py);
    Lz = - nx .* px - ny .* py;
    L = [Lx; Ly; Lz];

    L = LINE.unnormalize(L, K);
end