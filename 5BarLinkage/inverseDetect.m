function [theta1, theta2] = inverseDetect(Xp, Yp, l1, l2, l3, l4, l5, l6)
    initial_guess = [pi, pi];
    options = optimoptions('lsqnonlin', 'Display', 'iter', 'MaxFunctionEvaluations', 10^4, 'MaxIterations', 10^4);
    
    % Solve for the angles using the equations function
    solution = lsqnonlin(@(vars) equationsF(vars, Xp, Yp, l1, l2, l3, l4, l5, l6), initial_guess, [], [], options);
    theta1 = solution(1);
    theta2 = solution(2);
end

function F = equationsF(vars, Xp, Yp, l1, l2, l3, l4, l5, l6)
    [Px, Py] = solveP(vars, l1, l2, l3, l4, l5, l6);
    eq1 = Px - Xp;
    eq2 = Py - Yp;
    F = [eq1; eq2];
end

function [Px, Py] = solveP(vars, l1, l2, l3, l4, l5, l6)
    theta1 = vars(1);
    theta2 = vars(2);
    [~, ~, ~, ~, ~, P] = ForwardDetect(theta1, theta2, l1 ,l2 ,l4, l3 ,l5 ,l6);
    Px = double(P(1));
    Py = double(P(2));
end