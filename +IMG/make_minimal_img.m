function mimg = make_minimal_img(img, meas, model, res)
    nx = size(img,2);
    ny = size(img,1);
    mss = res.mss;
    circ = res.info.circ;
    figure('visible','off'); imshow(img);
    if isKey(mss,'arc')
        arcs = meas('arc');
        arc_ix = mss('arc');
        ARC.draw(arcs([arc_ix{:}]),'color',[1 0 1],'LineWidth',4)
        arc_ix2 = sum(1:numel(arcs)==[arc_ix{:}]');
        arc_ix2 = arc_ix2(res.info.cs);
        CIRCLE.draw(circ(:,find(arc_ix2)),'color','m','LineWidth',2,'LineStyle','--')
    end
    if isKey(mss,'rgn')
        rgn_ix = mss('rgn');
        x_mss = x(:,[rgn_ix{:}]);
        xu_mss = RP2.backproject_div(x_mss, model.K, model.proj_params);
        xu_l = cross(reshape(xu_mss(:,1),3,[]),reshape(xu_mss(:,2),3,[]));
        x_circ = LINE.project_div(xu_l,model.K, model.proj_params);
        for kk=1:numel(rgn_ix)
            ix = rgn_ix{kk};
            for k=1:3
                GRID.draw([x((k-1)*3+1:k*3,ix(1));x((k-1)*3+1:k*3,ix(2))],'color',[0 1 0],'size',1,'linewidth',4)
            end
        end
        CIRCLE.draw(x_circ,'color','g','LineWidth',2,'LineStyle','--')
    end
    xlim([1 nx])
    ylim([1 ny])
    fullscreen;
    mimg=getframe(gca).cdata;
    close all
end