%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function v = apply_rigid_xforms(u,Rt)
c = cos(Rt(1,:));
s = sin(Rt(1,:));
t = repmat([Rt(2:3,:); zeros(1,size(Rt,2))],3,1);
a11 = Rt(4,:);

Ru = ones(size(u));
Ru([1 2 4 5 7 8],:) = ...
    [ a11.*c.*u(1,:)-s.*u(2,:); ...
      a11.*s.*u(1,:)+c.*u(2,:); ...
      a11.*c.*u(4,:)-s.*u(5,:); ...
      a11.*s.*u(4,:)+c.*u(5,:); ...
      a11.*c.*u(7,:)-s.*u(8,:); ...
      a11.*s.*u(7,:)+c.*u(8,:) ];
v = Ru+t; 
