function plotWorkspace(app)
% Setup input joint angles
[th1, th2, th3] = ndgrid(app.angle, app.angle, app.angle);

% Initialize workspace variable
wrkspace = [];

% Initialize min and max values for x, y, z
minX = inf; maxX = -inf;
minY = inf; maxY = -inf;
minZ = inf; maxZ = -inf;

% Sweep through all possible angles
for i = 1:numel(th1)
    % Solve using forward kinematics
    [x, y, z] = FKinem(rad2deg(th1(i)), rad2deg(th2(i)), rad2deg(th3(i)), app.r, app.R, app.l, app.L);
    % If a solution exists, the point is part of the workspace
    if (isreal(x) && isreal(y) && isreal(z))
        sola = [x(1), y(1), z(1)];
        % Check if second solution exists
        if length(x) > 1
            solb = [x(2), y(2), z(2)];
            if (solb(3) < 0)
                wrkspace = cat(1, wrkspace, solb);
                % Update min and max values
                minX = min(minX, solb(1));
                maxX = max(maxX, solb(1));
                minY = min(minY, solb(2));
                maxY = max(maxY, solb(2));
                minZ = min(minZ, solb(3));
                maxZ = max(maxZ, solb(3));
            end
        else
            % Only one solution, check if it is valid
            if (sola(3) < 0)
                wrkspace = cat(1, wrkspace, sola);
                % Update min and max values
                minX = min(minX, sola(1));
                maxX = max(maxX, sola(1));
                minY = min(minY, sola(2));
                maxY = max(maxY, sola(2));
                minZ = min(minZ, sola(3));
                maxZ = max(maxZ, sola(3));
            end
        end
    end
end

% Convert workspace to double
wrkspace = double(wrkspace);

% Check if workspace is not empty before plotting
if ~isempty(wrkspace)
    % Change the button background color to green to indicate success
    app.Start.BackgroundColor = 'green';

    % Plot smooth workspace from alphaShape
    x = wrkspace(:,1);
    y = wrkspace(:,2);
    z = wrkspace(:,3);
    shp = alphaShape(x, y, z);

    % Extract boundary facets from the alpha shape
    [tri, xyz] = boundaryFacets(shp);

    % Plot the workspace on the specified UIAxes
    trisurf(tri, xyz(:,1), xyz(:,2), xyz(:,3), 'Parent', app.UIAxesWP);

    title(app.UIAxesWP, 'Delta Robot Workspace')
    xlabel(app.UIAxesWP, 'x (mm)')
    ylabel(app.UIAxesWP, 'y (mm)')
    zlabel(app.UIAxesWP, 'z (mm)')
    pbaspect(app.UIAxesWP, [1 1 1])


    % Calculate margins for slider ranges
    marginX = (maxX - minX) * 0.1;
    marginY = (maxY - minY) * 0.1;
    marginZ = (maxZ - minZ) * 0.1;

    % Set slider ranges with margin
    app.SliderX.Limits = [minX - marginX, maxX + marginX];
    app.SliderY.Limits = [minY - marginY, maxY + marginY];
    app.SliderZ.Limits = [minZ - marginZ, maxZ + marginZ];

    % Obtain workspace volume
    V = volume(shp);
    fprintf('Workspace Volume: %.2f cubic mm\n', V);
    fprintf('Min values: x = %.2f, y = %.2f, z = %.2f\n', minX, minY, minZ);
    fprintf('Max values: x = %.2f, y = %.2f, z = %.2f\n', maxX, maxY, maxZ);
else
    fprintf('No valid points found in the workspace.\n');
end
end