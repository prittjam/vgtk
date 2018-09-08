%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function A = hg_est_A_from_3p(u)
t1 = mean(u(1:2,:),2);
t2 = mean(u(3:4,:),2);
M = bsxfun(@minus,u([1 2 3 4],:),[t1;t2])';

[~,~,vv] = svd(M);
V = vv(:,1:2);
B = V(1:2,1:2);
C = V(3:4,1:2);
H = C*inv(B);

A = [H t2-H*t1; zeros(1,2) 1];