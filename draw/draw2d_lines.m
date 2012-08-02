function lh = draw2d_lines(ax1,l,varargin)
n = size(l,2);

axes(ax1);
v = axis;

x = [ [v(1) v(3) 1]' ...
      [v(2) v(3) 1]' ...
      [v(2) v(4) 1]' ... 
      [v(1) v(4) 1]' ];

top = repmat(cross(x(:,2),x(:,1)),1,n);
bottom = repmat(cross(x(:,3),x(:,4)),1,n);
left = repmat(cross(x(:,2),x(:,3)),1,n);
right = repmat(cross(x(:,1),x(:,4)),1,n);

pts3 = [renormI(cross(l,top)); ...
        renormI(cross(l,bottom)); ...
        renormI(cross(l,left)); ...
        renormI(cross(l,right))];

pts = pts3([1 2 4 5 7 8 10 11],:);

ia = [repmat((pts(1,:) > v(1)) & (pts(1,:) < v(2)),2,1);...
      repmat((pts(3,:) > v(1)) & (pts(3,:) < v(2)),2,1);...
      repmat((pts(6,:) > v(3)) & (pts(6,:) < v(4)),2,1);...
      repmat((pts(8,:) > v(3)) & (pts(8,:) < v(4)),2,1)];

pts2 = reshape(pts(ia(:)),2,[]);


hold on;
lh = line(reshape(pts2(1,:),2,[]), ...
          reshape(pts2(2,:),2,[]));
hold off;

if ~isempty(varargin)
    set(lh,varargin{:});
end