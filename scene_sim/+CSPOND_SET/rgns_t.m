function [x,cspond,G] = rgns_t(N,w,h,varargin)
    cfg = struct('direction', 'rand', 'direction2', 'none', 'regular', false);
    cfg = cmp_argparse(cfg,varargin{:});
    x0 = repmat(LAF.make_random(1),1,N);
    if ~strcmp(cfg.direction2, 'none')
        N0 = N;
        d = cfg.direction;
        d2 = cfg.direction2;
        d2 = d2 ./ norm(d2);
        x = [];
        N = 0;
        for m=(-N0:2:N0-1)/N0
            if cfg.regular
                t2 = (m * d2 + d .* (-N0:2:N0-1)/N0) .* 0.45;
            else
                t2 = (m * d2 + d .* rand(1,N0)) .* 0.45;
            end
            A = Rt.params_to_mtx([zeros(1,N0);t2;ones(1,N0)]);
            x2 = PT.mtimesx(A, x0);
            N = N + N0;
            x = [x x2];
        end
    else
        if strcmp(cfg.direction, 'rand')
            d = rand(2, 1) * 9 + 1;;
            d = d ./ norm(d);
        else
            d = cfg.direction;
            d = d ./ norm(d);
        end
        if cfg.regular
            t = d .* (-N:2:N-1)/N .* 0.45;
        else
            t = d .* rand(1,N) .* 0.45;
        end
        A = Rt.params_to_mtx([zeros(1,N);t;ones(1,N)]);
        x = PT.mtimesx(A, x0);
    end
    
    M = [[w 0; 0 h] [0 0]';0 0 1];
    x = reshape(M*reshape(x,3,[]),9,[]);
    cspond = transpose(nchoosek(1:N,2));
    G = repmat(1,1,N);
end