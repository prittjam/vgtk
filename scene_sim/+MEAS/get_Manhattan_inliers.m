function [meas_list, varinput_list] = get_Manhattan_inliers(meas, groups, model, res, varinput)
    error('WIP')
    x = meas{1};
    arcs = meas{2};
    x_csponds = label_to_cspond(groups{1});

    meas_list = {};
    varinput_list = {};

    for vp=1:3
        %%%% ARCS
        meas_ = MEAS.make_empty_list();
        varinput_ = MEAS.make_empty_list();
        meas_list{k} = meas_;
        varinput_list{k} = varinput_;

        %%%% RGNS
    end
end