function valid = filter_by_baseline(rgns, cspond, baselineT)
    if nargin < 3
        baselineT = 5; % px
    end
    dx = rgns(:,cspond(1,:))-rgns(:,cspond(2,:));
    sqerrs = [sum(dx(1:2,:).^2);sum(dx(4:5,:).^2);sum(dx(7:8,:).^2)];
    valid = ~(any(sqerrs<1e-7) | all(sqerrs<baselineT.^2));
end