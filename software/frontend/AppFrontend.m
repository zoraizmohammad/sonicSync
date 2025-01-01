% MATLAB Frontend Code

% Bluetooth Configuration
bt = bluetooth('ESP32_Device_Name', 1); % Replace 'ESP32_Device_Name' with the actual Bluetooth device name
fopen(bt);

% GUI Design
figure('Name', 'Acoustic Research Interface', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);

% User Interaction Controls
startButton = uicontrol('Style', 'pushbutton', 'String', 'Start Feedback', 'Callback', @startFeedback);
stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop Feedback', 'Callback', @stopFeedback);

soundSlider = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1, 'Value', 0.5, 'Callback', @adjustSound);
soundLabel = uicontrol('Style', 'text', 'String', 'Sound Volume');

% Real-time Data Visualization (Future Development)
% For now, let's assume a simple text display for the most recent sound and feedback
recentSoundLabel = uicontrol('Style', 'text', 'String', 'Recent Sound:');
recentSoundValue = uicontrol('Style', 'text', 'String', '');

recentFeedbackLabel = uicontrol('Style', 'text', 'String', 'Recent Feedback:');
recentFeedbackValue = uicontrol('Style', 'text', 'String', '');

% Event Handlers

function startFeedback(~, ~)
    % Send command to ESP-32 to start the feedback loop
    fprintf(bt, 'start_feedback');
end

function stopFeedback(~, ~)
    % Send command to ESP-32 to stop the feedback loop
    fprintf(bt, 'stop_feedback');
end

function adjustSound(~, ~)
    % Adjust sound volume based on the slider value
    volume = get(soundSlider, 'Value');
    fprintf(bt, 'adjust_volume:%f', volume);
end

% Main Loop (For Future Real-time Data Visualization)
while ishandle(recentSoundLabel)
    % Receive data from ESP-32
    data = fscanf(bt);
    
    % Process received data (assuming a simple string format)
    parts = strsplit(data, ':');
    
    % Update recent sound and feedback values
    recentSoundValue.String = parts{2};
    recentFeedbackValue.String = parts{4};
    
    drawnow;
end

% Cleanup
fclose(bt);
delete(bt);
