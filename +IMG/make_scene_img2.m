function [simg1, simg2, simg3] = make_scene_img2(img, meas, groups, res, model)
    nx = size(img,2);
    ny = size(img,1);

    if isfield(res.info,'circ')
        figure('visible','off'); imshow(img);
        arcs = meas('arc');
        arcs = arcs(res.info.cs);
        Gvpc = res.info.Gvp;
        CIRCLE.draw(res.info.circ,'color',Gvpc)
        ARC.draw(arcs,'color',Gvpc,'linewidth',4)
        GRID.draw(RP2.project_div(model.K*model.R,model.K,model.proj_params),'color','k','size',30)
        GRID.draw(RP2.project_div(model.K*model.R,model.K,model.proj_params))
        xlim([1 nx])
        ylim([1 ny])
        fullscreen;
        simg1=getframe(gca).cdata;
        close all
    else
        simg1=[];
    end

    if isfield(res,'rgn')
        figure('visible','off'); imshow(img);
        rgns = meas('rgn');
        cspond = res.rgn.info.cspond;
        Gvpx = res.rgn.info.Gvp;
        cs = res.rgn.info.cs;
        clr = eye(3);
        for k=1:3
            GRID.draw([rgns((k-1)*3+1:k*3,cspond(1,cs));rgns((k-1)*3+1:k*3,cspond(2,cs))],'color',clr(Gvpx(cs),:),'size',8,'linewidth',2)
        end 
        GRID.draw(RP2.project_div(model.K*model.R,model.K,model.proj_params),'color','k','size',30)
        GRID.draw(RP2.project_div(model.K*model.R,model.K,model.proj_params))
        xlim([1 nx])
        ylim([1 ny])
        fullscreen;
        simg2=getframe(gca).cdata;
        close all
        simg3 = [];
    else
        simg2 = [];
        simg3 = [];
    end
end