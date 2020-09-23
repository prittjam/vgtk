function simg = make_scene_img(img, ld, ud, x, cspond, Gvl, c, Gvp)
    nx = size(img,2);
    ny = size(img,1);

    clr.vl = {'y','c','m'};
    clr.vp = {'r','g','b'};

    figure('visible','off'); imshow(img);
    % Regions
    if ~isempty(x)
        GRID.draw(unique(reshape(x(:,[cspond(1,:) cspond(2,:)]),3,[])','rows')','color','#505050');
        for k=1:3
            GRID.draw(unique(reshape(...
            x(:,[cspond(1,Gvl==k) cspond(2,Gvl==k)]),3,[])','rows')',...
            'color',clr.vl{k});
        end
    end
    % Circles
    if ~isempty(c)
        CIRCLE.draw(c,'color','#505050','linewidth',1);
        for k=1:3
            CIRCLE.draw(c(:,Gvp==k),...
                        'color',clr.vp{k},'linewidth',1);
        end
    end
    % Vanishing lines and points
    for k=1:3
        CIRCLE.draw(ld(:,k), 'color','k','linewidth',4);
        CIRCLE.draw(ld(:,k), 'color',clr.vl{k},'linewidth',3);
    end
    for k=1:3
        GRID.draw(ud(:,k), 'color','k','size',50);
        GRID.draw(ud(:,k), 'color',clr.vp{k},'size',40);
    end
    xlim([1,nx]);
    ylim([1,ny]);
    fullscreen;
    simg=imresize(getframe(gca).cdata,[ny,nx]);
    close all
end