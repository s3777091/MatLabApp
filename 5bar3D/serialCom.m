% Initialize the serial port
clc; clear; close all; format compact; format shortG

s = serialport('/dev/tty.usbserial-21230', 115200);

configureTerminator(s, "LF"); % Setting the terminator to Line Feed

% Use this code to read data from the serial port
% Flush the previous data
flush(s);

% Example theta values (replace these with your calculated values)
theta1 = 180;
theta2 = 90;
theta3 = 45;

% Send theta1 as 'a' followed by the value, if not NaN
if ~isnan(theta1)
    write(s, sprintf('a%.2f\n', theta1), "string");
end

% Send theta2 as 's' followed by the value, if not NaN
if ~isnan(theta2)
    write(s, sprintf('s%.2f\n', theta2), "string");
end

% Send theta3 as 'd' followed by the value, if not NaN
if ~isnan(theta3)
    write(s, sprintf('d%.2f\n', theta3), "string");
end

% Example: Sending these values in a loop for testing
while true
    flush(s);
    data = readline(s);
    
    % Check if data is not empty
    if ~isempty(data)
        disp(['Received data: ', data]);

        % Parse the string based on the known format "X: %.2f, Y: %.2f, Z: %d"
        parsedData = sscanf(data, 'X: %f, Y: %f, Z: %d');
        
        % Check if the parsing was successful
        if length(parsedData) == 3
            % Extract X, Y, Z values
            X = parsedData(1);
            Y = parsedData(2);
            Z = parsedData(3);
            % Display the values
            disp(['X: ', num2str(X)]);
            disp(['Y: ', num2str(Y)]);
            disp(['Z: ', num2str(Z)]);

            [theta1, theta2, theta3] = IKinem(X, Y, Z, 35.03, 70.5, 457.95, 110.49);
        else
            disp('Error: Data format does not match expected format.');
        end
    else
        disp('Warning: No data received within the timeout period.');
    end

    disp(['Updated theta1: ', num2str(theta1)]);
    disp(['Updated theta2: ', num2str(theta2)]);
    disp(['Updated theta3: ', num2str(theta3)]);


    % Send updated theta values, if not NaN
    if ~isnan(theta1)
        write(s, sprintf('a%.2f\n', theta1), "string");
        pause(0.02);
    end
    if ~isnan(theta2)
        write(s, sprintf('s%.2f\n', theta2), "string");
        pause(0.02);
    end
    if ~isnan(theta3)
        write(s, sprintf('d%.2f\n', theta3), "string");
        pause(0.02);
    end

    pause(1); % Pause for 1 second (adjust as needed)
end
