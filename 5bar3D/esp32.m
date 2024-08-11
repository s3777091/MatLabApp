url = 'http://192.168.4.1/data';

while true
    clc;
    data = webread(url);

    % Access the values of x, y, and z
    x_value = data.x;
    y_value = data.y;
    z_value = data.z;

    % Display the values
    disp(['x: ', num2str(x_value)]);
    disp(['y: ', num2str(y_value)]);
    disp(['z: ', num2str(z_value)]);

    pause(2);
end