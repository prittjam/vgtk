function varargout = eg_est_F_7p_rnsc(u,s,threshold,confidence)
T = pt_make_hartley_xform(renormI([u(1:3,s) u(4:6,s)]));

cfg.s = 7;
cfg.t = pt_get_hartley_threshold(T,threshold);
cfg.confidence = confidence;
cfg.max_trials = 1e5;

cfg.sample_degen_fn = @eg_sample_degen;
cfg.sample_degen_args = { cfg.t };

% model functions
cfg.est_fn = @eg_est_7p_tlsq;
cfg.error_fn = @(u,F) sum(eg_sampson_err(u,F).^2);

cfg = rnsc_standardize_cfg(cfg);

%cfg.lo = make_eg_inner_rnsc_cfg(cfg);
%cfg.lo.fn = @eg_inner_rnsc;
%
[res, cfg] = rnsc_estimate(blkdiag(T,T)*u,s,cfg);

%cfg.model_args.model =  res.model;
%cfg.epsilon = 0;
%res = guided_sampling(blkdiag(T,T)*u, logical(res.weights), cfg);

res.model = T'*res.model*T;
res.errors = sum(eg_sampson_err(u,res.model).^2);

varargout = { res };

if nargout == 2
    varargout = cat(2,varargout,cfg);
end