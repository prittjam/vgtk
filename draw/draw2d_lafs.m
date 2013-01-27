function draw2d_lafs(ax1,u,varargin)
x = reshape(u(1:3:end,:),3,[]);
y = reshape(u(2:3:end,:),3,[]);

hold all;
h1 = plot(x,y, ...
          'LineWidth'       , 3,           varargin{:});
%          'MarkerEdgeColor','k', ...
%          'MarkerFaceColor',[.49 1 .63], ...
%          'MarkerSize',4, ...


%plot(x(1:3:end)',y(1:3:end)','o', ...
%     'LineWidth'       , 2, ...
%     'MarkerEdgeColor','k', ...
%     'MarkerFaceColor',[0.43 0.81 0.96], ...
%     'MarkerSize',5);
hold off;