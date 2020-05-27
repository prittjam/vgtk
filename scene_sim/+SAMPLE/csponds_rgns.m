%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,idx,G] = csponds_rgns(sample_type,w,h,varargin)
    cfg = struct('rigidxform', 'Rt');
    cfg = cmp_argparse(cfg,varargin{:});

    switch sample_type
      case 'r2'
        [X,cspond,G] = CSPOND_SET.rgns_t(2,w,h);
        
      case 'r22'
        [X0,cspond0,G0] = CSPOND_SET.rgns_t(2,w,h);
        [X1,cspond1,G1] = CSPOND_SET.rgns_t(2,w,h);
        X = [X0 X1];
        cspond = [cspond0 cspond1+max(cspond0(:))];
        G = [G0 G1+max(G0)];

      case 'r222'
        [X0,cspond0,G0] = CSPOND_SET.rgns_t(2,w,h);
        [X1,cspond1,G1] = CSPOND_SET.rgns_t(2,w,h);
        [X2,cspond2,G2] = CSPOND_SET.rgns_t(2,w,h);
        X = [X0 X1 X2];
        cspond1 = cspond1+max(cspond0(:));
        cspond2 = cspond2+max(cspond1(:));
        cspond = [cspond0 cspond1 cspond2];
        G1 = G1+max(G0);
        G2 = G2+max(G1);
        G = [G0 G1 G2];
        
      case 'r32'
        [X0,cspond0,G0] = CSPOND_SET.rgns_t(3,w,h);
        [X1,cspond1,G1] = CSPOND_SET.rgns_t(2,w,h);
        X = [X0 X1];
        cspond = [cspond0 cspond1+max(cspond0(:))];
        G = [G0 G1+max(G0)];
        
      case 'r4'
        [X,cspond,G] = CSPOND_SET.rgns_t(4,w,h);
    end

    uG = unique(G);

    for k = 1:numel(uG)
        idx{k} = find(G == uG(k));
    end
