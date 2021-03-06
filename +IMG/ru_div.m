%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [timg,trect,T,S] = ru_div(img,cc,q,varargin)
cfg = struct('border', [], ...
             'size', size(img));

[cfg,varargin] = cmp_argparse(cfg,varargin{:});

T0 = CAM.make_ru_div_tform(cc,q);

nx = size(img,2);
ny = size(img,1);

if ~isempty(cfg.border)
    border = cfg.border;
else
    border = [1  1; ...
              nx 1; ...    
              nx ny; ...
              1  ny];
end

[T,S] = IMG.register_by_size(T0,border,cfg.size, ...
                             'LockAspectRatio', false);

tbounds = tformfwd(T,border);

minx = min(tbounds(:,1));
maxx = max(tbounds(:,1));
miny = min(tbounds(:,2));
maxy = max(tbounds(:,2));

timg = imtransform(img,T,'bicubic', ...
                   'XYScale',1, ...
                   'XData',[minx maxx], ...
                   'YData',[miny maxy], ...
                   'FillValues', 255);

trect = [minx miny maxx maxy];