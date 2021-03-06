%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function Ha = laf1x2_to_A(v)
m = size(v,2);
if m == 1
    Ha =  LAF.pt3x3_to_A(v(10:18,:))*inv(LAF.pt3x3_to_A(v(1:9,:)));
else
    u = reshape(v([1:2 10:11 4:5 13:14 7:8 16:17],:),4,[]);    
    Ha = HG.pt3x2_to_A(u);
end
