function draw_KRt(K, Rt, varargin)
    cfg = struct('nx', 1000, 'ny', 1000, 'dX', 30, 'fov', []);
    cfg = cmp_argparse(cfg, varargin{:});

    alpha_c = K(1, 2);
    fc(1) = K(1, 1);
    fc(2) = K(2, 2);
    cc(1) = K(1, 3);
    cc(2) = K(2, 3);
    
    nx = cfg.nx;
    ny = cfg.ny;
    dX = cfg.dX;

    if ndims(Rt)==2
      Rts = reshape(Rt,3,4,1);
    else
      Rts = Rt;
    end
    for k=1:size(Rts,3)
      R = Rts(:,1:3,k);
      t = Rts(:,4,k);
  
      % step 1: image plane to camera coordinate system
      IP = dX*[1 -alpha_c 0;...
                0  1       0;...
                0  0       1] *...
              [1/fc(1) 0       0;...
                0       1/fc(2) 0;...
                0       0       1] *...
              [1 0 -cc(1);...
                0 1 -cc(2);...
                0 0  1] *...
              [0 nx-1 nx-1 0    0;...
                0 0    ny-1 ny-1 0;...
                1 1    1    1    1];
      BASE = dX*([0 1 0 0 0 0;...
                  0 0 0 1 0 0;...
                  0 0 0 0 0 1]);
  
      IP = reshape([IP;BASE(:,1)*ones(1,5);IP],3,15);
  
      % step 2: camera coordinate system to world coordinate system
      BASE = R' * (BASE - t * ones(1, 6));
      IP = R' * (IP - t * ones(1, 15));
  
      hold on;
      plot3(BASE(1,[1 2]),BASE(2,[1 2]), BASE(3,[1 2]),'r-','linewidth',2'); % x-axis
      plot3(BASE(1,[3 4]),BASE(2,[3 4]), BASE(3,[3 4]),'g-','linewidth',2'); % y-axis
      plot3(BASE(1,[5 6]),BASE(2,[5 6]), BASE(3,[5 6]),'b-','linewidth',2'); % z-axis
      plot3(IP(1,:),IP(2,:), IP(3,:), 'k-','linewidth',1);
    end

    if ~isempty(cfg.fov)
      r = dX*20;
      [X,Y] = meshgrid(-r:dX/10:r);
      Z = sqrt(X.^2 + Y.^2) * cos(cfg.fov/180*pi/2);
      Z(X.^2 + Y.^2 > r^2) = NaN;
      pts = [reshape(X,1,[]);reshape(Y,1,[]);reshape(Z,1,[])];
      pts2 = R' * (pts - t * ones(1, size(pts,2)));
      X = reshape(pts2(1,:),size(X));
      Y = reshape(pts2(2,:),size(Y));
      Z = reshape(pts2(3,:),size(Z));
      hold on
      % contour3(X,Y,Z,50,'k:')
      s = surf(X,Y,Z);
      s.EdgeColor = 'none';
      s.FaceColor = 'k';
      s.FaceAlpha = '0.1';
    end
  end