function [X, cspond] = board_to_world(structures)
    X = [];
    cspond = [];
    for n=1:numel(structures)
        str = structures(n);
        K = size(str.X,2);
        if size(str.X,1) == 2
            X_ = [str.X; zeros(1,K)];
        else
            X_ = str.X;
        end
        X = [X str.Rt * RP3.homogenize(X_)];
        cspond = [cspond...
            [1:K; ones(1,K)*n]];
    end
end