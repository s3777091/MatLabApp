function serialComApp(app)
% Initialize the serial port
s = serialport('/dev/tty.usbserial-21230', 115200);
configureTerminator(s, "LF"); % Setting the terminator to Line Feed

% Flush the previous data
flush(s);

% Send app.th1deg as 'a' followed by the value, if not NaN
if ~isnan(app.th1deg)
    write(s, sprintf('a%.2f\n', app.th1deg), "string");
end

% Send app.th2deg as 's' followed by the value, if not NaN
if ~isnan(app.th2deg)
    write(s, sprintf('s%.2f\n', app.th2deg), "string");
end

% Send app.th3deg as 'd' followed by the value, if not NaN
if ~isnan(app.th3deg)
    write(s, sprintf('d%.2f\n', app.th3deg), "string");
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

            [app.th1deg, app.th2deg, app.th3deg] = IKinem(X, Y, Z, 35.03, 70.5, 457.95, 110.49);
        else
            disp('Error: Data format does not match expected format.');
        end
    else
        disp('Warning: No data received within the timeout period.');
    end

    disp(['Updated app.th1deg: ', num2str(app.th1deg)]);
    disp(['Updated app.th2deg: ', num2str(app.th2deg)]);
    disp(['Updated app.th3deg: ', num2str(app.th3deg)]);

    % Send updated theta values, if not NaN
    if ~isnan(app.th1deg)
        write(s, sprintf('a%.2f\n', app.th1deg), "string");
        pause(0.02);
    end
    if ~isnan(app.th2deg)
        write(s, sprintf('s%.2f\n', app.th2deg), "string");
        pause(0.02);
    end
    if ~isnan(app.th3deg)
        write(s, sprintf('d%.2f\n', app.th3deg), "string");
        pause(0.02);
    end

    pause(1); % Pause for 1 second (adjust as needed)
end
end