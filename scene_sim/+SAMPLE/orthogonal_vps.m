function [X, cspond, idx, G, L, S, Lcspond, Lidx, LG] = orthogonal_vps(sample_type, w, h)
    % Two orthogonal directions on the scene plane
    % The others are arbitrary if applies
    switch sample_type
    case 'r22'
        [X,cspond,G] = CSPOND_SET.rgns_t(2,w,h,'direction',[1; 0],'regular',true);
        [X1,cspond1,G1] = CSPOND_SET.rgns_t(2,w,h,'direction',[0; 1],'regular',true);
        X = [X X1]; cspond = [cspond cspond1+max(cspond(:))]; G = [G G1+max(G)];
        L = NaN; S = NaN; Lcspond = NaN; LG = NaN; Lidx = NaN;
    case 'r222'
        [X0,cspond0,G0] = CSPOND_SET.rgns_t(2,w,h,'direction',[1; 0],'regular',true);
        [X1,cspond1,G1] = CSPOND_SET.rgns_t(2,w,h,'direction',[0; 1],'regular',true);
        [X2,cspond2,G2] = CSPOND_SET.rgns_t(2,w,h,'direction',[0.5; 0.4],'regular',true);
        X = [X0 X1 X2];
        cspond1 = cspond1+max(cspond0(:));
        cspond2 = cspond2+max(cspond1(:));
        cspond = [cspond0 cspond1 cspond2];
        G1 = G1+max(G0);
        G2 = G2+max(G1);
        G = [G0 G1 G2];
        L = NaN; S = NaN; Lcspond = NaN; LG = NaN; Lidx = NaN;
    case 'r2c2'
        [L, S, Lcspond, LG] = CSPOND_SET.lines(2, w, h,'direction',[1; 0],'regular',true);
        [X,cspond,G] = CSPOND_SET.rgns_t(2,w,h,'direction',[0; 1],'regular',true);
    case 'c222'
        [L0, S0, Lcspond0, LG0] = CSPOND_SET.lines(2, w, h,...
                        'direction',[1; 0], 'regular',true);
        if rand()<0.5
            [L1, S1, Lcspond1, LG1] = CSPOND_SET.lines(2, w, h,'direction',[0; 1],'regular',true);
            [L2, S2, Lcspond2, LG2] = CSPOND_SET.lines(2, w, h,'regular',true);
            L = [L0 L1 L2];
            S = [S0 S1 S2];
            Lcspond1 = Lcspond1 + max(Lcspond0(:));
            Lcspond2 = Lcspond2 + max(Lcspond1(:));
            Lcspond = [Lcspond0 Lcspond1 Lcspond2];
            LG1 = LG1 + max(LG0);
            LG2 = LG2 + max(LG1);
            LG = [LG0 LG1 LG2];
        else % 'c222s'
            [L1, S1, Lcspond1, LG1] = CSPOND_SET.lines(4, w, h,'direction',[0; 1],'regular',true);
            L = [L0 L1];
            S = [S0 S1];
            Lcspond1 = Lcspond1 + max(Lcspond0(:));
            Lcspond = [Lcspond0 Lcspond1];
            LG1 = LG1 + max(LG0);
            LG = [LG0 LG1];
        end
        X = NaN; cspond = NaN; idx = NaN; G = NaN; idx = NaN;
    case 'c32'
        [L0, S0, Lcspond0, LG0] = CSPOND_SET.lines(3, w, h,'direction',[1; 0],'regular',true);
        [L1, S1, Lcspond1, LG1] = CSPOND_SET.lines(2, w, h,'direction',[0; 1],'regular',true);
        L = [L0 L1];
        S = [S0 S1];
        Lcspond = [Lcspond0 Lcspond1+max(Lcspond0(:))];
        LG = [LG0 LG1+max(LG0)];
        X = NaN; cspond = NaN; idx = NaN; G = NaN; idx = NaN;
    otherwise
        L = NaN; S = NaN; Lcspond = NaN; LG = NaN; Lidx = NaN;
        X = NaN; cspond = NaN; idx = NaN; G = NaN; idx = NaN;
    end
    if ~isnan(X)
        uG = unique(G);
        for k = 1:numel(uG)
            idx{k} = find(G == uG(k));
        end
    end
    if ~isnan(L)
        uLG = unique(LG);
        for k = 1:numel(uLG)
            Lidx{k} = find(LG == uLG(k));
        end
    end
  end