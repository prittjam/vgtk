function [T,S,border] = register_by_size(T0,border,sz,varargin)
    cfg.lockaspectratio = true;
    [cfg,leftover] = cmp_argparse(cfg,varargin{:});
    
    cc = mean(border);
    tborder = tformfwd(T0,border);

    while any(isnan(tborder))
        border = cc + 0.95 * (border - cc);
        tborder = tformfwd(T0, border);
    end

    xextent = max(tborder(:,1))-min(tborder(:,1));
    yextent = max(tborder(:,2))-min(tborder(:,2));

    nx = sz(2);
    ny = sz(1);
    s = [(nx-1)/xextent (ny-1)/yextent];
    
    if cfg.lockaspectratio
        s = min(s);
        S = [s 0 0; ...
             0 s 0; ...
             0 0 1];
    else
        S = [s(1)  0     0; ...
             0     s(2)  0; ...
             0     0     1];
    end

    T = maketform('composite', ...
                  maketform('affine',S'), T0);

% S_tform = maketform('affine',S');
% shift = -min(tformfwd(S_tform, tborder));
% Tr = [1 0 shift(1);...
%     0 1 shift(2);...
%     0 0 1];
% Tr_tform = maketform('projective', Tr');
% T = maketform('composite', Tr_tform, S_tform, T0);