function plotKinematics(app)
    % Clear the axes
    cla(app.UIAxesKN); 
    hold(app.UIAxesKN, 'on');
    grid(app.UIAxesKN, 'on');
    axis(app.UIAxesKN, 'equal');
    
    % Set the limits and labels of the axes
    xlim(app.UIAxesKN, [-300 300]);
    ylim(app.UIAxesKN, [-300 300]);
    zlim(app.UIAxesKN, [-300 300]);
    xlabel(app.UIAxesKN, 'X (mm)');
    ylabel(app.UIAxesKN, 'Y (mm)');
    zlabel(app.UIAxesKN, 'Z (mm)');
    title(app.UIAxesKN, '3D Inverse Kinematics');
    view(app.UIAxesKN, 3);

    % Calculate the base circle points
    x1 = app.R * cos(app.theta); % X-axis points for the base circle
    y1 = app.R * sin(app.theta); % Y-axis points for the base circle
    z1 = zeros(1, 100); % Z-axis points for the base circle

    % Plot the base circle
    plot3(app.UIAxesKN, x1, y1, z1, 'LineWidth', 2);

    try
        % Read the current position values from the UI controls
        X = app.Xmm.Value;
        Y = app.Ymm.Value;
        Z = app.Zmm.Value;
        
        % Calculate joint angles using inverse kinematics
        [th1, th2, th3, fl] = IKinem(X, Y, Z, app.r, app.R, app.l, app.L);
        app.th1deg.Value = th1;
        app.th2deg.Value = th2;
        app.th3deg.Value = th3;
        
        if fl == -1
            disp(['Invalid value for position: X=', num2str(X), ...
                ', Y=', num2str(Y), ', Z=', num2str(Z)]);
            return;
        end

        th = [th1, th2, th3];

        % Base points
        A1 = [app.R*cosd(0), app.R*sind(0), 0];
        A2 = [app.R*cosd(120), app.R*sind(120), 0];
        A3 = [app.R*cosd(240), app.R*sind(240), 0];

        % Links positions
        B1 = A1 + [app.L*cosd(th(1)), app.L*sind(th(1)), 0];
        B2 = A2 + [app.L*cosd(th(2) + 120), app.L*sind(th(2) + 120), 0];
        B3 = A3 + [app.L*cosd(th(3) + 240), app.L*sind(th(3) + 240), 0];

        % Define points C1, C2, C3 as tangent points of the second circle
        C1 = [X + app.r*cosd(0), Y + app.r*sind(0), Z];
        C2 = [X + app.r*cosd(120), Y + app.r*sind(120), Z];
        C3 = [X + app.r*cosd(240), Y + app.r*sind(240), Z];

        circle2X = X + app.r * cos(app.theta);
        circle2Y = Y + app.r * sin(app.theta);
        circle2Z = Z * ones(1, length(app.theta));

        % Plot the links from base to the moving platform
        plot3(app.UIAxesKN, [A1(1) B1(1)], [A1(2) B1(2)], [A1(3) B1(3)], 'k', 'LineWidth', 2);
        plot3(app.UIAxesKN, [A2(1) B2(1)], [A2(2) B2(2)], [A2(3) B2(3)], 'k', 'LineWidth', 2);
        plot3(app.UIAxesKN, [A3(1) B3(1)], [A3(2) B3(2)], [A3(3) B3(3)], 'k', 'LineWidth', 2);

        % Plot lines from B points to C points
        plot3(app.UIAxesKN, [B1(1) C1(1)], [B1(2) C1(2)], [B1(3) C1(3)], 'k', 'LineWidth', 2);
        plot3(app.UIAxesKN, [B2(1) C2(1)], [B2(2) C2(2)], [B2(3) C2(3)], 'k', 'LineWidth', 2);
        plot3(app.UIAxesKN, [B3(1) C3(1)], [B3(2) C3(2)], [B3(3) C3(3)], 'k', 'LineWidth', 2);

        % Plot points C1, C2, C3
        plot3(app.UIAxesKN, C1(1), C1(2), C1(3), 'ro', 'MarkerSize', 10);
        plot3(app.UIAxesKN, C2(1), C2(2), C2(3), 'go', 'MarkerSize', 10);
        plot3(app.UIAxesKN, C3(1), C3(2), C3(3), 'bo', 'MarkerSize', 10);

        % Plot the moving circle centered at [X, Y, Z]
        plot3(app.UIAxesKN, circle2X, circle2Y, circle2Z, 'LineWidth', 2);
        plot3(app.UIAxesKN, X, Y, Z, 'o', 'MarkerSize', 10);

    catch ME
        disp(['No valid solution found for position: X=', num2str(X), ...
            ', Y=', num2str(Y), ', Z=', num2str(Z)]);
        disp(ME.message);
    end
end