close all;
clc;
clear;

global l1 l2 l3 l4 l5 l6;

l1 = 3.0; % Length of link BC
l2 = 4.0; % Length of link AD
l3 = 4.0; % Length of link DE
l4 = 3.0; % Length of link CE
l5 = 2.0; % Length of link EP
l6 = 5.0; % Length of link AB

% Function to plot the mechanism
function plotMechanism(theta1, theta2)
    global l1 l2 l3 l4 l5 l6

    [A, B, C, D, E, P] = ForwardDetect(theta1, theta2, l1, l2, l3, l4, l5, l6);
    
    subplot(2, 2, 1);
    hold on;
    plot([A(1), D(1), E(1), C(1), B(1)], [A(2), D(2), E(2), C(2), B(2)], 'bo-');
    plot([A(1), B(1)], [A(2), B(2)], 'bo-');
    plot([E(1), P(1)], [E(2), P(2)], 'ro-'); % EP
    axis equal;
    xlim([-10, 10]);
    ylim([-10, 10]);
    title('Mechanism');
    hold off;
end

% Main function to run the kinematics and plot the results
function main()
    global l1 l2 l3 l4 l5 l6;
    % Define the range for theta1 and theta2
    theta1_range_up = linspace(deg2rad(180), deg2rad(360), 200);
    theta2_range_up = linspace(deg2rad(180), deg2rad(360), 200);
    theta1_range_down = linspace(deg2rad(360), deg2rad(180), 200);
    theta2_range_down = linspace(deg2rad(360), deg2rad(180), 200);

    Px = [];
    Py = [];
    theta1_vals = [];
    theta2_vals = [];
    
    figure('units', 'normalized', 'outerposition', [0 0 1 1]); % Full-screen figure
    
    % Loop through the upward range to animate the mechanism
    for i = 1:length(theta1_range_up)
        theta1_a = theta1_range_up(i);
        theta2_a = theta2_range_up(i);

        % Plot the mechanism
        subplot(2, 2, 1);
        cla; % Clear the subplot
        plotMechanism(theta1_a, theta2_a);
        drawnow;

        % Collect trajectory data
        [~, ~, ~, ~, ~, P] = ForwardDetect(theta1_a, theta2_a, l1, l2, l3, l4, l5, l6);
        Px = [Px, P(1)];
        Py = [Py, P(2)];
        theta1_vals = [theta1_vals, theta1_a];
        theta2_vals = [theta2_vals, theta2_a];

        % Plot the trajectory of P in a separate subplot
        subplot(2, 2, 2);
        plot(Px, Py, 'b.-');
        xlabel('P_x');
        ylabel('P_y');
        title('Trajectory of Point P');
        axis equal;
        xlim([-10, 10]);
        ylim([-10, 10]);
        grid on;
        drawnow;
        
        % Plot theta1 and theta2 in a separate subplot
        subplot(2, 2, [3 4]);
        plot(theta1_vals, 'g.-'); % Green line for theta1
        hold on;
        plot(theta2_vals, 'r.-'); % Red line for theta2
        hold off;
        xlabel('Iteration');
        ylabel('Angle (rad)');
        title('Theta1 (green) and Theta2 (red) vs Iterations');
        xlim([1, length(theta1_range_up)]);
        ylim([deg2rad(180), deg2rad(360)]);
        grid on;
        drawnow;
    end

    % Print the range of Px and Py after finishing the upward range
    disp('Range of Px:');
    disp(['Min: ', num2str(min(Px)), ' Max: ', num2str(max(Px))]);
    disp('Range of Py:');
    disp(['Min: ', num2str(min(Py)), ' Max: ', num2str(max(Py))]);

    % Loop through the downward range to animate the mechanism
    for i = 1:length(theta1_range_down)
        theta1_a = theta1_range_down(i);
        theta2_a = theta2_range_down(i);

        % Plot the mechanism
        subplot(2, 2, 1);
        cla; % Clear the subplot
        plotMechanism(theta1_a, theta2_a);
        drawnow;

        % Collect trajectory data
        [~, ~, ~, ~, ~, P] = ForwardDetect(theta1_a, theta2_a, l1, l2, l3, l4, l5, l6);
        Px = [Px, P(1)];
        Py = [Py, P(2)];
        theta1_vals = [theta1_vals, theta1_a];
        theta2_vals = [theta2_vals, theta2_a];

        % Plot the trajectory of P in a separate subplot
        subplot(2, 2, 2);
        plot(Px, Py, 'b.-');
        xlabel('P_x');
        ylabel('P_y');
        title('Trajectory of Point P');
        axis equal;
        xlim([-10, 10]);
        ylim([-10, 10]);
        grid on;
        drawnow;

        % Plot theta1 and theta2 in a separate subplot
        subplot(2, 2, [3 4]);
        plot(theta1_vals, 'g.-'); % Green line for theta1
        hold on;
        plot(theta2_vals, 'r.-'); % Red line for theta2
        hold off;
        xlabel('Iteration');
        ylabel('Angle (rad)');
        title('Theta1 (green) and Theta2 (red) vs Iterations');
        xlim([1, length(theta1_range_down)]);
        ylim([deg2rad(180), deg2rad(360)]);
        grid on;
        drawnow;
    end
end

main();