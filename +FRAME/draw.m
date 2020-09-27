function draw(Rt, varargin)
    if nargin < 1 || isempty(Rt)
        Rt = [eye(3) zeros(3,1)];
    end
    cfg = struct('dX', 100);
    cfg = cmp_argparse(cfg, varargin{:});
    dX = cfg.dX;

    if ndims(Rt)==2
      Rts = reshape(Rt,3,4,1);
    else
      Rts = Rt;
    end
    for k=1:size(Rts,3)
      R = Rts(:,1:3,k);
      t = Rts(:,4,k);
      BASE = dX*([0 1 0 0 0 0;...
                  0 0 0 1 0 0;...
                  0 0 0 0 0 1]);
  
      BASE = R' * (BASE - t * ones(1, 6));
  
      hold on;
      plot3(BASE(1,[1 2]),BASE(2,[1 2]), BASE(3,[1 2]),'r-','linewidth',2'); % x-axis
      plot3(BASE(1,[3 4]),BASE(2,[3 4]), BASE(3,[3 4]),'g-','linewidth',2'); % y-axis
      plot3(BASE(1,[5 6]),BASE(2,[5 6]), BASE(3,[5 6]),'b-','linewidth',2'); % z-axis
    end
  end