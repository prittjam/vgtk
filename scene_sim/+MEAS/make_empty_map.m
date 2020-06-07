function m = make_empty_map()
    % m = containers.Map({'rgn', 'arc', 'lineseg'},{[], [], []});
    m = containers.Map();
    m('rgn') = [];
    m('arc') = [];
    m('lineseg') = [];
    m('linept') = [];
end
