function masks = make_ld_masks(ld, l, cntr, cntr_ud, nx, ny)
    cntr_vl_dist = diag(l' * cntr_ud)';
    cntr_vl_side = [cntr_vl_dist < 0];

    clr.mask = {'w','k'};
    masks = {};
    for k=1:3
        masks01 = {};
        for s=0:1
            figure('visible','off');
            rectangle('Position',[1 1 nx ny],'FaceColor',clr.mask{(cntr_vl_side(k)==s)+1});
            rectangle('Position',[ld(1:2,k)'-ld(3,k) 2*ld(3,k) 2*ld(3,k)],'FaceColor',clr.mask{(cntr_vl_side(k)~=s)+1},'Curvature',[1 1]);
            axis ij
            xlim([0,nx]);
            ylim([0,ny]);
            fullscreen;
            masks01{s+1} = imresize(getframe(gca).cdata,[ny,nx]);
            close all
        end
        masks{k} = masks01;
    end
end