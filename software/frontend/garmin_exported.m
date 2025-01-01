classdef garmin_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                     matlab.ui.Figure
        TextToSendEditField          matlab.ui.control.EditField
        TextToSendEditFieldLabel     matlab.ui.control.Label
        setDataMatrixEditField       matlab.ui.control.EditField
        setDataMatrixEditFieldLabel  matlab.ui.control.Label
        loadwavfileButton            matlab.ui.control.Button
    end

    
    properties (Access = private)
        Arduino % Description
        fileName % Description
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: setDataMatrixEditField
        function setDataMatrixEditFieldValueChanged(app, event)
            app.fileName = app.setDataMatrixEditField.Value;
            app.fileName = app.fileName + ".mat"
            save(app.fileName)
        end

        % Button pushed function: loadwavfileButton
        function loadwavfileButtonPushed(app, event)
            load(app.fileName)
            [file,path] = uigetfile('*.wav')
            [audioData,fs] = audioread(file);
            soundsc(audioData,fs)
            TotalTime = length(audioData)./fs
            %delay(TotalTime)
            pause(TotalTime)
            [audioData1,fs1] = audioread("test1.wav");
            soundsc(audioData1,fs1)

            a =  arduino;
            dataValue = readVoltage(a, 'A0')
            if (dataValue <= 1.25)
                rating = "worst";
            end 
            if (dataValue >= 1.25 && dataValue <= 2.5)
                rating = "bad";
            end 
            if (dataValue >= 2.5 && dataValue <= 3.75)
                rating = "better";
            end 
            if (dataValue >= 3.75)
                rating = "best";
            end 
            dataSet = [file, rating]
            a = cat(1,a, dataSet)
            save(app.fileName,'-append','a')

        
            synthesizer = speechClient("IBM");
            [speech,fs] = text2speech(synthesizer,textSend);
            sound(speech,fs);
            


        end

        % Value changed function: TextToSendEditField
        function TextToSendEditFieldValueChanged(app, event)
            textSend = app.TextToSendEditField.Value;
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create loadwavfileButton
            app.loadwavfileButton = uibutton(app.UIFigure, 'push');
            app.loadwavfileButton.ButtonPushedFcn = createCallbackFcn(app, @loadwavfileButtonPushed, true);
            app.loadwavfileButton.Position = [39 360 100 23];
            app.loadwavfileButton.Text = 'load .wav file ';

            % Create setDataMatrixEditFieldLabel
            app.setDataMatrixEditFieldLabel = uilabel(app.UIFigure);
            app.setDataMatrixEditFieldLabel.HorizontalAlignment = 'right';
            app.setDataMatrixEditFieldLabel.Position = [14 410 80 22];
            app.setDataMatrixEditFieldLabel.Text = 'setDataMatrix';

            % Create setDataMatrixEditField
            app.setDataMatrixEditField = uieditfield(app.UIFigure, 'text');
            app.setDataMatrixEditField.ValueChangedFcn = createCallbackFcn(app, @setDataMatrixEditFieldValueChanged, true);
            app.setDataMatrixEditField.Position = [109 410 100 22];

            % Create TextToSendEditFieldLabel
            app.TextToSendEditFieldLabel = uilabel(app.UIFigure);
            app.TextToSendEditFieldLabel.HorizontalAlignment = 'right';
            app.TextToSendEditFieldLabel.Position = [20 304 74 22];
            app.TextToSendEditFieldLabel.Text = 'Text To Send';

            % Create TextToSendEditField
            app.TextToSendEditField = uieditfield(app.UIFigure, 'text');
            app.TextToSendEditField.ValueChangedFcn = createCallbackFcn(app, @TextToSendEditFieldValueChanged, true);
            app.TextToSendEditField.Position = [109 304 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = garmin_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end