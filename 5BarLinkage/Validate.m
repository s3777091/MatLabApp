close all;
clc;
clear;

% Define global variables
global l1 l2 l3 l4 l5 l6

l1 = 3.0; % Length of link BC
l2 = 4.0; % Length of link AD
l3 = 4.0; % Length of link DE
l4 = 3.0; % Length of link CE
l5 = 2.0; % Length of link EP
l6 = 5.0; % Length of link AB

Xp = 4.285;
Yp = -4.06;
[theta1_deg, theta2_deg] = inverseDetect(Xp, Yp, l1, l2, l3, l4, l5, l6);
[A, B, C, D, E, P] = ForwardDetect(theta1_deg, theta2_deg, l1, l2, l4, l3, l5, l6);
disp(['Px: ', num2str(double(P(1)))]);
disp(['Py: ', num2str(double(P(2)))]);