%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function s = cam_get_crop_factor(ccd_sz)
s = 1 ;
if ccd_sz(1)/ccd_sz(2) < 1.5
    s = 24*10^-3/ccd_sz(2);
else
    s = 36*10^-3/ccd_sz(1);
end