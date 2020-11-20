function [rimgs, T_rect] = make_orthophotos(img, masks, model, base_path, sufx, varargin)
    cfg.reiterate = false;
    cfg.vl_min_dist = 0.3;
    cfg.simgs = [];
    cfg.uimg = [];
    cfg.meas = [];
    cfg.size = [];
    cfg = cmp_argparse(cfg, varargin{:});
    if isempty(cfg.size)
        cfg.size = size(img);
    end 

    nx = size(img,2);
    ny = size(img,1);
    
    vl_min_dist = cfg.vl_min_dist * max(ny,nx);

    border_x = [1 nx nx 1; ny ny 1 1; 1 1 1 1];
    border_x_ud = CAM.backproject_div(border_x, model.K, model.proj_params);
    border_vl_dist = (model.l' * border_x_ud);
    border_vl_side = [border_vl_dist < 0];

    N = 3;

    uimg = cfg.uimg;
    simgs = cfg.simgs;
    meas = cfg.meas;
    
    nx = size(img,2);
    ny = size(img,1);

    close all;
    
    T_rect = ones(3,3,3,2) * NaN;
    for k=1:N
        for s=0:1
            rimgs{k}{s+1} = NaN;
        end
    end
    for k=1:N
        for s=0:1
            display(num2str([k,s]))
            if ~cfg.reiterate || java.lang.System.getProperty( 'java.awt.headless' )
                ld0{1} = LINE.project_div([model.l(1:2,:); model.l(3,:)-vl_min_dist],model.K, model.proj_params);
                ld0{2} = LINE.project_div([model.l(1:2,:); model.l(3,:)+vl_min_dist],model.K, model.proj_params);
                
                intr = {};
                intr{1} = CIRCLE.intersect_rect(ld0{1}, border_x);
                intr{1} = cellfun(@(x) x(:,all(x(1:2,:)>=[1;1]) & all(x(1:2,:)<=[nx;ny])), intr{1}, 'UniformOutput', false);
                intr{2} = CIRCLE.intersect_rect(ld0{2}, border_x);
                intr{2} = cellfun(@(x) x(:,all(x(1:2,:)>=[1;1]) & all(x(1:2,:)<=[nx;ny])), intr{2}, 'UniformOutput', false);
                border=[intr{s+1}{k} border_x(:,border_vl_side(k,:)==s)];
                if size(border,2) > 1
                    [rimgs{k}{s+1},xborder,~,T]=IMG.ru_div_rectify(...
                            max(img,masks{k}{s+1}),...
                            model.Hs(:,:,k), model.cc, model.q, ...
                            'size', cfg.size,...
                            'border', 2*border(1:2,:)', ...
                            'Registration', 'none');
                    T(1:2,3) = -xborder(1:2)';
                    T_rect(:,:,k,s+1) = T;
                    imwrite(rimgs{k}{s+1}, [base_path '_rect' num2str((k-1)*2+s+1) sufx '.jpg'])
                end
            else
                T0 = eye(3);
                while true
                    ld0{1} = LINE.project_div([model.l(1:2,:); model.l(3,:)-vl_min_dist],model.K, model.proj_params);
                    ld0{2} = LINE.project_div([model.l(1:2,:); model.l(3,:)+vl_min_dist],model.K, model.proj_params);
                    
                    intr = {};
                    intr{1} = CIRCLE.intersect_rect(ld0{1}, border_x);
                    intr{1} = cellfun(@(x) x(:,all(x(1:2,:)>=[1;1]) & all(x(1:2,:)<=[nx;ny])), intr{1}, 'UniformOutput', false);
                    intr{2} = CIRCLE.intersect_rect(ld0{2}, border_x);
                    intr{2} = cellfun(@(x) x(:,all(x(1:2,:)>=[1;1]) & all(x(1:2,:)<=[nx;ny])), intr{2}, 'UniformOutput', false);
                    border=[intr{s+1}{k} border_x(:,border_vl_side(k,:)==s)];
                    if size(border,2) > 1
                        [rimgs{k}{s+1},xborder,~,T]=IMG.ru_div_rectify(...
                            max(img,masks{k}{s+1}),...
                            model.Hs(:,:,k), model.cc, model.q, ...
                            'size', cfg.size,...
                            'border', border(1:2,:)', ...
                            'Registration', 'none',...
                            'final_T',T0);
                        n0x = size(rimgs{k}{s+1},2);
                        n0y = size(rimgs{k}{s+1},1);
                        nx = cfg.size(2);
                        ny = cfg.size(1);
                        x0 = (n0x-nx) /2;
                        y0 = (n0y-ny) /2;
                        rimgs{k}{s+1} = imcrop(rimgs{k}{s+1}, [x0 y0 nx ny]);
                        close all;
                        imshow(rimgs{k}{s+1})
                        ans = input('Keep(Y/y/N/n): ', 's');
                    else
                       break 
                    end
                    if strcmp(upper(ans),'N')
                        break
                    else
                        ans = input('Resize(Y/y/N/n): ', 's');
                        if strcmp(upper(ans),'N')
                            T(1:2,3) = -xborder(1:2)';
                            T_rect(:,:,k,s+1) = T;
                            imwrite(rimgs{k}{s+1}, [base_path '_rect' sufx '.jpg'])
                            return
                        else
                            display(['Current vl_min_dist is: ' num2str(vl_min_dist)])
                            ans = input('Input new one or skip (ENTER): ');
                            if ~isempty(ans)
                                vl_min_dist = ans;
                            else
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end