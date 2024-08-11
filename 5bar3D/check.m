% Main script for Delta Robot Kinematics and Visualization with Animation
close all;
clc;
clear;

% Define platform's position (x, y, z)
a = 20;
b = -9;
c = -248;
% Run inverse kinematics to get joint angles using fmincon
[theta1, theta2, theta3] = IKinem(a, b, c);
% Display the calculated joint angles in degrees
disp('Inverse Kinematics Joint Angles (in degrees):');
disp(['Theta 1: ', num2str(theta1)]);
disp(['Theta 2: ', num2str(theta2)]);
disp(['Theta 3: ', num2str(theta3)]);
[X, Y, Z] = FKinem(theta1, theta2, theta3);
disp('Forward Kinematics Joint Angles (in degrees):');
disp(['X: ', num2str(X)]);
disp(['Y: ', num2str(Y)]);
disp(['Z: ', num2str(Z)]);