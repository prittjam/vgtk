function masks = make_ld_masks(ld, l, pp, nx, ny)
    pp_vl_dist = (l' * pp)';
    pp_vl_side = [pp_vl_dist < 0];

    clr.mask = {'k','w'};
    masks = {};
    for k=1:3
        masks01 = {};
        for s=0:1
            figure('visible','off');
            rectangle('Position',[1 1 nx ny],'FaceColor',clr.mask{(pp_vl_side(k)==s)+1});
            rectangle('Position',[ld(1:2,k)'-ld(3,k) 2*ld(3,k) 2*ld(3,k)],'FaceColor',clr.mask{(pp_vl_side(k)~=s)+1},'Curvature',[1 1]);
            axis ij
            xlim([1,nx]);
            ylim([1,ny]);
            fullscreen;
            masks01{s+1} = imresize(getframe(gca).cdata,[ny,nx]);
            close all
        end
        masks{k} = masks01;
    end
end