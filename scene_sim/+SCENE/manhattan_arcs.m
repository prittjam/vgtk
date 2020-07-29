function gt = manhattan_arcs(sigma_list, outliers)
    if nargin < 1 || isempty(sigma_list)
        sigma_list = [3 0.5 1.5];
    end
    if nargin < 2
        outliers = true;
    end
    while true
        try
            e = eye(3);

            N = [5 5 5];

            q = -1.5;
            f_mm = 5;
            ccd_mm = 4.8;
            cam = CAM.make_ccd(f_mm, ccd_mm, 1000, 1000);
            cam = CAM.make_lens(cam, q, 'div');
            cam = CAM.make_viewpoint(cam);

            cam.vp_ud = cam.P34 * [e; zeros(1,3)];

            cc = [570; 520];
            T = cam.K;
            T(1:2,3) = cc;

            wplane = 10;
            hplane = 10;

            lines = [];
            endpoints = [];
            for ix=1:numel(N)
                if (e(1,ix)<1e-11) && (e(2,ix)<1e-11)
                    [L, S] = CSPOND_SET.lines(N(ix), wplane, hplane,...
                    'direction', [1;0;0], 'regular', true);
                    l = cam.P34(:, [3 1 4])' \ L;
                    s = RP2.mtimesx(cam.P34(:, [3 1 4]), reshape(S,6,[]));
                else
                    [L, S] = CSPOND_SET.lines(N(ix), wplane, hplane,...
                        'direction', e(:,ix), 'regular', true);
                    l = cam.P' \ L;
                    s = RP2.mtimesx(cam.P, reshape(S,6,[]));
                end
                lines = [lines l];
                endpoints = [endpoints s];
            end

            project_fn = str2func(['LINE.' cam.proj_fn]);
            circles = project_fn(lines, T, cam.proj_params);
            project_fn = str2func(['RP2.' cam.proj_fn]);
            s = project_fn(endpoints, T, cam.proj_params);
            [p, n] = ARC.get_midpoint(circles, s);
            arcs = ARC.sample(circles, s, 'num_pts', round(rand(1,sum(N))*100+100));

            vp_labels = [ones(1,N(1)) 2*ones(1,N(2)) 3*ones(1,N(3))];

            % Noise generation
            for k=1:3
                arcs(vp_labels==k) = ...
                    ARC.add_noise(arcs(vp_labels==k),...
                                  sigma_list(k),...
                                  circles(:,vp_labels==k));
            end

            % Outliers
            if outliers
                N_o = 5;
                circles_o = rand(3,N_o) * 1000;
                s1_o = CIRCLE.project([rand(2,N_o) * 1000; ones(1,N_o)], circles_o);
                s2_o = CIRCLE.project(s1_o+[rand(2,N_o) * 200+100; zeros(1,N_o)], circles_o);
                s_o = [s1_o; s2_o];
                arcs_o = ARC.sample(circles_o, s_o, 'num_pts', round(rand(1,N_o)*100+100));
                labels_o = ones(1,numel(arcs_o))*NaN;
            else
                arcs_o = {};
                labels_o = [];
            end

            vp = project_fn(cam.vp_ud, T, cam.proj_params);

            circles_norm = CIRCLE.normalize(circles, T);
            arcs_norm = ARC.normalize(arcs, T);
            vp_norm = RP2.normalize(vp, T);

            arcs_o_norm = ARC.normalize(arcs_o, T);
            
            vp0 = T\vp(:,vp_labels);
            circles0 = CIRCLE.normalize(circles, T);

            vp_radius = vecnorm(vp0(1:2,:),2,1);
            vp_radius_sqr = vp_radius.^2;

            k = (1 + q * vp_radius_sqr) ./ (2 * q * vp_radius_sqr);

            alpha1 = (circles0(1,:) - k .* vp0(1,:)) .* vp_radius ./ vp0(2,:);
            alpha2 =-(circles0(2,:) - k .* vp0(2,:)) .* vp_radius ./ vp0(1,:);

            assert(all(abs(alpha1-alpha2)<1e-11))
            
            gt = struct();
            gt.alpha = (alpha1+alpha2)/2;
            gt.K = cam.K;
            gt.f = gt.K(1,1);
            gt.R = cam.R;
            gt.t = cam.c;
            gt.cc = cc;
            gt.vp_ud = cam.vp_ud;
            gt.vp = vp;
            % gt.vp_norm = vp_norm;
            gt.q = cam.proj_params;
            gt.imsize_x = cam.nx;
            gt.imsize_y = cam.ny;
            gt.circles = circles;
            % gt.circles_norm = circles_norm;
            gt.arcs = {arcs{:} arcs_o{:}};
            % gt.arcs_norm = [arcs_norm{:}];
            gt.vp_labels = [vp_labels labels_o];
            % savejson2(gt, GetFullPath('~/gt.json'));
            % save('~/gt.mat', 'gt')
            % keyboard

            %%%%%%%%%%%%%%%% DRAW DISTORTED
            close all
            CIRCLE.draw(gt.circles,'Color',gt.vp_labels)
            ARC.draw(gt.arcs,'LineWidth',2,'Color',gt.vp_labels,'MarkerSize',10)
            GRID.draw(gt.vp,'Size',30)
            GRID.draw([gt.cc; 1],'Size',30,'Color','k')
            xlim([0 1000])
            ylim([0 1000])
            %%%%%%%%%%%%%%%%
        catch
            continue
        end
        break
    end
end
