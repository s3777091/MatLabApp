close all;
clc;
clear;

global l1 l2 l3 l4 l5 l6

l1 = 3.0; % Length of link BC
l2 = 4.0; % Length of link AD
l3 = 4.0; % Length of link DE
l4 = 3.0; % Length of link CE
l5 = 2.0; % Length of link EP
l6 = 5.0; % Length of link AB

% Main function to run the kinematics and plot the results
function main()
    clf;
    hold on;
    axis([-10, 10, -10, 10]);
    title('Click to set point P. Press any key to exit.');
    
    % Set initial point
    Xp = 4.285;
    Yp = -4.06;
    plotFigure(Xp, Yp);
    
    % Update point on click
    while true
        [Xp, Yp, button] = ginput(1);
        if isempty(button) % Exit on any key press
            break;
        end
        clf;
        plotFigure(Xp, Yp);
    end
    
    hold off;
end

function plotFigure(Xp, Yp)
    global l1 l2 l3 l4 l5 l6

    % Check if the point is valid
    if ~isValidPoint(Xp, Yp, l1, l2, l3, l4, l5, l6)
        disp('Invalid point P. Please select another point.');
        return;
    end

    % Calculate angles (inverse kinematics)
    try
        [theta1, theta2] = inverseDetect(Xp, Yp, l1, l2, l3, l4, l5, l6);
    catch ME
        disp('Error in inverse kinematics calculation. Please select another point.');
        % Return default values for point P
        Xp = 4.285;
        Yp = -4.06;
        [theta1, theta2] = inverseDetect(Xp, Yp, l1, l2, l3, l4, l5, l6);
    end
    [A, B, C, D, E, P] = ForwardDetect(theta1, theta2, l1, l2, l4, l3, l5, l6);

    plot([A(1), D(1), E(1), C(1), B(1)], [A(2), D(2), E(2), C(2), B(2)], 'bo-');
    hold on;
    plot([A(1), B(1)], [A(2), B(2)], 'bo-');
    plot([E(1), P(1)], [E(2), P(2)], 'ro-'); % EP
    axis([-10, 10, -10, 10]);
    axis equal;
    hold off;
end

function valid = isValidPoint(Xp, Yp, l1, l2, l3, l4, l5, l6)
    totalLength = l1 + l2 + l3 + l4 + l5 + l6;
    distanceFromOrigin = sqrt(Xp^2 + Yp^2);
    if distanceFromOrigin > totalLength
        valid = false;
    else
        valid = true;
    end
end

main();