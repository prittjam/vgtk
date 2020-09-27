function Rt = board_to_world(Rt0, Rt1)
    % Args:
    %   Rt0 -- from board point B to world point A: A = R0*B + t0 
    %   Rt1 -- from board point B to image point C: C = R1*B + t1
    %
    % Returns:
    %   Rt -- from world point A to image point C: C = R*A + t

    Rt = FRAME.compose(FRAME.inv(Rt0), Rt1);
end

% FRAME.draw; axis equal
% GRID.draw3d(X(:,cspond(2,:)==2),'color','r');
% GRID.draw3d([boards(2).X;zeros(1,size(boards(2).X,2))],'color','g');
% GRID.draw3d(x(:,cspond(2,:)==2),'color','b');

% Rt1 = FRAME.inv(boards(2).Rt);
% Rt2 = [cam.R cam.c];

% Rt3 = CAM.board_to_world(Rt1, Rt2)

% GRID.draw3d(Rt1 * RP3.homogenize(X(:,cspond(2,:)==2)),'color','k');
% GRID.draw3d(Rt2 * RP3.homogenize(X(:,cspond(2,:)==2)),'color','k');

% GRID.draw3d(Rt3 * RP3.homogenize([boards(2).X;zeros(1,size(boards(2).X,2))]),'color','k');

