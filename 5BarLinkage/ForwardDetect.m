% Forward kinematics function
function [A, B, C, D, E, P] = ForwardDetect(theta1, theta2, l1 ,l2 ,l4, l3 ,l5 ,l6)
    % Define points A and B
    A = [0, 0];
    B = [l6, 0];
    
    % Calculate the position of joints D and C
    D = [l2 * cos(theta2), l2 * sin(theta2)];
    C = [l6 + l1 * cos(theta1), l1 * sin(theta1)];
    
    % Calculate the position of joint E using the intersection of two circles
    % Circle centered at D with radius l3
    % Circle centered at C with radius l4
    
    % Vector from D to C
    d = C - D;
    d_norm = norm(d);
    
    % Check if the circles intersect
    if d_norm > (l3 + l4) || d_norm < abs(l3 - l4)
        error('No intersection between the circles');
    end
    
    % Calculate the intersection points
    a = (l3^2 - l4^2 + d_norm^2) / (2 * d_norm);
    h = sqrt(l3^2 - a^2);
    
    % Point P2
    P2 = D + (a / d_norm) * d;
    
    % Intersection points E1 and E2
    E1 = P2 + h * [d(2), -d(1)] / d_norm;
    E2 = P2 - h * [d(2), -d(1)] / d_norm;
    
    E = E1; % Select the appropriate intersection point
    
    % Calculate the position of point P along the direction from E
    vector_DE = [E(1) - D(1), E(2) - D(2)];
    vector_DE = vector_DE / norm(vector_DE);
    P = E + l5 * vector_DE;
end