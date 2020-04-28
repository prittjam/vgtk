%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function model_list = est_F_from_7p(ut)
model_list = { };

M = size(ut,2);
u = ut';

A = [ u(:,4).*u(:,1) u(:,4).*u(:,2) u(:,4) u(:,5).*u(:,1) u(:,5).*u(:,2) ...
              u(:,5)         u(:,1) u(:,2)      ones(M,1) ];
F = null(A);

if size(F,2) > 2 
    warning('Degenerate sample encountered');
    return; 
end

c =EG.calc_7p_coeffs(F);
a = cubicfcn(c(4),c(3),c(2),c(1));
a = a(abs(imag(a))<10*eps);

if length(a) == 2
    warning(['Something is very wrong. The solution for to the cubic ' ...
             'generated by the determinant of the linear combination ' ...
             'of the two null spaces should have either 1 or 3 roots. ' ...
             'For a proof, please refer to Hartley.']);
end

F1 = reshape(F(:,1),3,3);
F2 = reshape(F(:,2),3,3);

for l = a
    model_list = cat(1,model_list,reshape(F(:,1)*l+F(:,2)*(1-l),3,3)');
end