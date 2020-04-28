%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function d = Fa_dist(u,F)
X = [u(4:5,:); ...
     u(1:2,:); ...
     ones(1,size(u,2))];
f = [F(1:2,3)' F(3,1:2) F(3,3)]';
f(1:4) = f(1:4)./sum(f(1:4).^2);
d = bsxfun(@rdivide,sum(bsxfun(@times,f,X)),sqrt(sum(f(1:4).^2)));