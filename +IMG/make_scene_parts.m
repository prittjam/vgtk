function simgs = make_scene_img(img, ld, l, ud, x, xu, cspond, Gvl, c, Gvp)
    nx = size(img,2);
    ny = size(img,1);

    clr.vl = {'y','c','m'};
    clr.vp = {'r','g','b'};

    vl_dist = (l' * xu(1:3,:));
    vl_side = [vl_dist < 0];

    k2 = [1 2; 2 3; 1 3];
    simgs = {};
    for k=1:3
        simgs01 = {};
        for s=0:1
            figure('visible','off'); imshow(img);
            % Regions
            if ~isempty(x)
                GRID.draw(x(:,intersect(find(vl_side(k,:)==s),[cspond(1,Gvl==k) cspond(2,Gvl==k)])), 'color',clr.vl{k});
            end
            % Circles
            if ~isempty(c)
                for k3=k2(k,:)
                    CIRCLE.draw(c(:,Gvp==k3),...
                                'color',clr.vp{k3},'linewidth',1);
                end
            end
            % Vanishing lines and points
            CIRCLE.draw(ld(:,k), 'color','k','linewidth',4);
            CIRCLE.draw(ld(:,k), 'color',clr.vl{k},'linewidth',3);
            for k3=k2(k,:)
                GRID.draw(ud(:,k3), 'color','k','size',50);
                GRID.draw(ud(:,k3), 'color',clr.vp{k3},'size',40);
            end
            xlim([0,nx]);
            ylim([0,ny]);
            fullscreen;
            simgs01{s+1} = imresize(getframe(gca).cdata,[ny,nx]);
            close all
        end
        simgs{k} = simgs01;
    end
end