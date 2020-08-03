%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function cam = make_ccd(f_mm, ccd_mm, nx, ny, pp, a, s)
      if nargin < 5 || isempty(pp)
            pp = [nx / 2 + 0.5; ny / 2 + 0.5];
      end
      if nargin < 6 || isempty(a)
            a = 1;
      end
      if nargin < 7 || isempty(s)
            s = 0;
      end
      f = nx * f_mm / ccd_mm;
      K = [a*f s*f pp(1); 0 f/a pp(2); 0 0 1];
      fov = 2 * atan2(ccd_mm / 2, f_mm);
      cam = struct('K', K, ...
                   'f', f, ...
                   'pp', pp, ...
                   'hfov', fov, ...
                   'ccd_mm', ccd_mm, ...
                   'f_mm', f_mm, ...
                   'nx', nx, ...
                   'ny', ny);
end