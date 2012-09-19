function model_list = ao_est_Rt_from_3p(u,s,varargin)
Xw = u(4:7,s);

res = p3p_grunert(Xw,u(1:3,s));

model_list = cell(1,numel(res));

for r = res
    Xc = r{1};
    [R t] = XX2Rt_simple(Xw,Xc);
    model_list{i} = [R t];
end