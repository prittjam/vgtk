%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function img  = draw_raster(img,x1,y1,x2,y2,varargin)
cfg = struct;
cfg.linewidth = 5;
cfg.channel = 1;
cfg = cmp_argparse(cfg, varargin{:});
linewidth = cfg.linewidth;
channel = cfg.channel;

% distances according to both axes
xn = abs(x2-x1);
yn = abs(y2-y1);

% interpolate against axis with greater distance between points;
% this guarantees statement in the under the first point!
if (xn > yn)
    xc = x1 : sign(x2-x1) : x2;
    yc = round(interp1([x1 x2], [y1 y2], xc, 'linear'));
    xc = round(xc);
else
    yc = y1 : sign(y2-y1) : y2;
    xc = round(interp1([y1 y2], [x1 x2], yc, 'linear'));
    yc = round(yc);
end

% add linewidth
k_up = round((linewidth-1)/2);
for k=1:k_up
    ind = find(yc+k<size(img,1));
    yc = [yc yc(ind)+k];
    xc = [xc xc(ind)];
end
for k=1:k_up
    ind = find(xc+k<size(img,2));
    xc = [xc xc(ind)+k];
    yc = [yc yc(ind)];
end
k_down = k_up - mod(linewidth-1,2);
for k=1:k_down
    ind = find(yc-k>0);
    yc = [yc yc(ind)-k];
    xc = [xc xc(ind)];
end
for k=1:k_down
    ind = find(xc-k>0);
    xc = [xc xc(ind)-k];
    yc = [yc yc(ind)];
end
% k_up = round((linewidth-1)/2);
% for k=1:k_up
%     yk = sqrt(2) / 2 * k;
%     xk = sqrt(2) / 2 * k;
%     yind = yc+yk<size(img,1);
%     xind = xc+xk<size(img,2);
%     ind = find(yind & xind);
%     yc = round([yc yc(ind)+yk]);
%     xc = round([xc xc(ind)+xk]);
% end
% k_down = k_up - mod(linewidth-1,2);
% for k=1:k_down
%     yk = sqrt(2) / 2 * k;
%     xk = sqrt(2) / 2 * k;
%     yind = yc-yk>0;
%     xind = xc-xk>0;
%     ind = find(yind & xind);
%     yc = round([yc yc(ind)-yk]);
%     xc = round([xc xc(ind)-xk]);
% end

% 2-D indexes of line are saved in (xc, yc), and
% 1-D indexes are calculated here:
if ndims(img)==3
    channels = [1 2 3];
    channels = channels(channels~=channel);
    for k=1:numel(channels)
        ind = sub2ind(size(img), yc, xc,...
                      channels(k)*ones(1,numel(yc)));
        img(ind) = 0;
    end
    for k=1:numel(channel)
        ind = sub2ind(size(img), yc, xc,...
                      channel(k)*ones(1,numel(yc)));
        img(ind) = 255;
    end
else
    ind = sub2ind( size(img), yc, xc);
    % draw line on the image (change value of '255' to one that you need)
    img(ind) = 255;
end
