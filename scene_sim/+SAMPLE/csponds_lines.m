function [L, S, Lcspond, Lidx, LG] = csponds_lines(sample_type, w, h)
    switch sample_type
        case 'r2c2'
            [L, S, Lcspond, LG] = CSPOND_SET.lines(2, w, h,'regular',true);
        case 'c222'
            [L0, S0, Lcspond0, LG0] = CSPOND_SET.lines(2, w, h,'regular',true);
            [L1, S1, Lcspond1, LG1] = CSPOND_SET.lines(2, w, h,'regular',true);
            [L2, S2, Lcspond2, LG2] = CSPOND_SET.lines(2, w, h,'regular',true);
            L = [L0 L1 L2];
            S = [S0 S1 S2];
            Lcspond1 = Lcspond1 + max(Lcspond0(:));
            Lcspond2 = Lcspond2 + max(Lcspond1(:));
            Lcspond = [Lcspond0 Lcspond1 Lcspond2];
            LG1 = LG1 + max(LG0);
            LG2 = LG2 + max(LG1);
            LG = [LG0 LG1 LG2];
        case 'c32'
            [L0, S0, Lcspond0, LG0] = CSPOND_SET.lines(3, w, h,'regular',true);
            [L1, S1, Lcspond1, LG1] = CSPOND_SET.lines(2, w, h,'regular',true);
            L = [L0 L1];
            S = [S0 S1];
            Lcspond = [Lcspond0 Lcspond1+max(Lcspond0(:))];
            LG = [LG0 LG1+max(LG0)];
        case 'c222s'
            [L0, S0, Lcspond0, LG0] = CSPOND_SET.lines(2, w, h,'regular',true);
            [L1, S1, Lcspond1, LG1] = CSPOND_SET.lines(4, w, h,'regular',true);
            L = [L0 L1];
            S = [S0 S1];
            Lcspond1 = Lcspond1 + max(Lcspond0(:));
            Lcspond = [Lcspond0 Lcspond1];
            LG1 = LG1 + max(LG0);
            LG = [LG0 LG1];
          otherwise
            L = NaN; S = NaN; Lcspond = NaN; LG = NaN; Lidx = NaN;
            return
    end
    uLG = unique(LG);
    for k = 1:numel(uLG)
        Lidx{k} = find(LG == uLG(k));
    end
  end