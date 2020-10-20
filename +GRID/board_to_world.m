function [X, cspond] = board_to_world(boards)
    X = [];
    cspond = [];
    for n=1:numel(boards)
        b = boards(n);
        K = size(b.X,2);
        if size(b.X,1) == 2
            X_ = [b.X; zeros(1,K)];
        else
            X_ = b.X;
        end
        X = [X b.Rt * RP3.homogenize(X_)];
        cspond = [cspond...
            [1:K; ones(1,K)*n]];
    end
end