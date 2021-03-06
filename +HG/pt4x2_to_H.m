%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = pt4x2_to_H(v)
u = PT.renormI(v(1:3,:));
u0 = PT.renormI(v(4:6,:));

m = size(u,2);
z = zeros(m,3);
M = [u' z  bsxfun(@times,-u0(1,:),u)'; ...
     z  u' bsxfun(@times,-u0(2,:),u)'];  

S = eye(size(M,2),size(M,2));
if m > 4
    S = diag(1./max(abs(M)));
end
invS = diag(1./diag(S));

[U S V] = svd(M*S);
H = { reshape(invS*V(:,end),3,3)' };
