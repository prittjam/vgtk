function heatmaps = make_heatmaps(meas, model, res, render, nx, ny, varargin)
    cfg.sigma = 1;
    cfg = cmp_argparse(cfg, varargin);

    keyboard

    % Get original region points
    x = meas('rgn');
    % Get region pair indices
    cspond = res.info('rgn').cspond;
    % Get vanishing line labeling for region pairs
    Gvl = res.info('rgn').Gvl;
    % Undistort points
    xu = RP2.backproject_div(x,model.K,model.proj_params);
    xu2 = RP2.mtimesx(render.T_ud, xu);
    % Create a filter for region locations wrt vanishing line (negative / positive)
    x_dist = (model.l' * xu(1:3,:));
    x_side = [x_dist < 0];

    % Get original arc points
    y = meas('arc');
    % Get vanishing point labeling for arcs
    Gvp = res.info('arc').Gvp;
    % Undistort points
    yu = cellfun(@(x) RP2.backproject_div(x,model.K,model.proj_params),y,'UniformOutput',false);
    yu2 = cellfun(@(x) render.T_ud*x, yu, 'UniformOutput',false);
    % Create a filter for arc locations wrt vanishing line (negative / positive)
    y_dist = cellfun(@(x) model.l' * x(:,1), yu, 'UniformOutput', false);
    y_dist = [y_dist{:}];
    y_side = [y_dist < 0];

    k2 = [1 2; 2 3; 1 3];

    for k=1:3
        for s=0:1
            % Rectify region points
            xr = RP2.renormI(RP2.mtimesx(render.T_rect(:,:,k,s+1)*model.Hs(:,:,k),xu));
            % Filter region points
            x_idx = intersect(find(x_side(k,:)==s),[cspond(1,Gvl==k) cspond(2,Gvl==k)]);

            % Rectify arc points
            yr = cellfun(@(x) RP2.renormI(render.T_rect(:,:,k,s+1) * model.Hs(:,:,k) * x), yu, 'UniformOutput',false);
            % Filter arc points
            y_idx = intersect(find(y_side(k,:)==s), [find(Gvp==k2(k,1)) find(Gvp==k2(k,2))]);

            pts = yr(:,y_idx);
            pts = [pts{:} reshape(xr(:,x_idx),3,[])];
            pts = pts(:,all(pts>0) & pts(1,:)<=nx & pts(2,:)<=ny);
            pts = round(unique(pts','rows')');
            heatmap = zeros(ny,nx);
            for k=1:size(pts,2)
                heatmap(pts(2,k),pts(1,k)) = 1;
            end
            heatmap = imgaussfilt(heatmap,5);
            heatmap = heatmap ./ max(heatmap,[],'all');
            fig; imshow(heatmap)
        end
    end
end