%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function is_degen = check_oriented(u,sample,weights,F,cfg)
m = numel(F);
is_degen = false(1,m);
for k = 1:m
    a =EG.get_orientation(u(:,sample),F{k});
    is_degen(k) = any(a ~= a(1));
end