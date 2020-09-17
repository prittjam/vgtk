function rimgs = make_orthophotos(img, masks, model, varargin)
    cfg.reiterate = false;
    cfg.plot = false;
    cfg.vl_min_dist = 0.05;
    cfg.simgs = [];
    cfg.uimg = [];
    cfg.meas = [];
    cfg = cmp_argparse(cfg, varargin{:});

    nx = size(img,2);
    ny = size(img,1);
    
    vl_min_dist = cfg.vl_min_dist * max(ny,nx);
    uimg = cfg.uimg;
    simgs = cfg.simgs;
    meas = cfg.meas;

    border_x = [1 nx nx 1; ny ny 1 1; 1 1 1 1];
    border_x_ud = CAM.backproject_div(border_x, model.K, model.proj_params);
    border_vl_dist = (model.l' * border_x_ud);
    border_vl_side = [border_vl_dist < 0];

    N = 3;
    if ~cfg.reiterate
        rimgs = rectify(img, masks, model, vl_min_dist, border_x, border_vl_side);
    else
        while true
            rimgs = rectify(img, masks, model, vl_min_dist, border_x, border_vl_side);
            if cfg.plot
                fig;
                subplot(4,2+N,1); imshow(img); MEAS.draw(meas)
                subplot(4,2+N,2); imshow(uimg);
                for s = 0:1
                    for k = 1:N
                        subplot(4,2+N,(2+N)*(2*s)+k+2)
                        imshow(simgs{k}{s+1});
                        if ~isnan(rimgs{k}{s+1})
                            subplot(4,2+N,(2+N)*(2*s+1)+k+2)
                            imshow(rimgs{k}{s+1});
                        end
                    end
                end
                ans = input('Retry(Y/y/N/n): ', 's');
                if strcmp(upper(ans),'N')
                    break
                else
                    display(['Current vl_min_dist is: ' num2str(vl_min_dist)])
                    ans = input('Input new one or skip (ENTER): ');
                    if ~isempty(ans)
                        vl_min_dist = ans;
                    else
                        break
                    end
                end
            else
                break
            end
        end
    end
end

function rimgs = rectify(img, masks, model, vl_min_dist, border_x, border_vl_side)
    N = 3;
    
    nx = size(img,2);
    ny = size(img,1);

    ld0{1} = LINE.project_div([model.l(1:2,:); model.l(3,:)-vl_min_dist],model.K, model.proj_params);
    ld0{2} = LINE.project_div([model.l(1:2,:); model.l(3,:)+vl_min_dist],model.K, model.proj_params);

    close all;
    
    intr = {};
    intr{1} = CIRCLE.intersect_rect(ld0{1}, border_x);
    intr{1} = cellfun(@(x) x(:,all(x(1:2,:)>=[1;1]) & all(x(1:2,:)<=[nx;ny])), intr{1}, 'UniformOutput', false);
    intr{2} = CIRCLE.intersect_rect(ld0{2}, border_x);
    intr{2} = cellfun(@(x) x(:,all(x(1:2,:)>=[1;1]) & all(x(1:2,:)<=[nx;ny])), intr{2}, 'UniformOutput', false);
    
    for k=1:N
        for s=0:1
            border = [intr{s+1}{k} border_x(:,border_vl_side(k,:)==s)];
            % border = IMG.input_border(simgs{k}{s+1}, 4,...
            %                             ['Click on 4 points for '... 
            %                     'the border of the '...
            %                     num2str(k) 'nd plane.']);
            if size(border,2) > 1
                rimgs{k}{s+1} = IMG.ru_div_rectify(...
                                    max(img,masks{k}{s+1}),...
                                    model.Hs(:,:,k),...
                                    model.cc, model.q, ...
                                    'size', size(img),...
                                    'border', border(1:2,:)', ...
                                    'Registration', 'none');
            else
                rimgs{k}{s+1} = NaN;
            end
        end
    end
end