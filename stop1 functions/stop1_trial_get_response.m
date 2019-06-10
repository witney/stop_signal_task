%%modified 4/23/09 by Nicki Swann for standard stopping
function [exp, td] = stop1_trial_get_response(exp, td, w, timing)
% Display prompts & stimuli, and get key responses    
   
%% draw the fixation

    stop1_draw_background(exp, w);
    old_color = Screen('TextColor', w, 255); %white
    DrawFormattedText(w, '+', 'center', 'center');
    Screen('TextColor', w, old_color);

    % don't flip until the proper time
    % the third argument to Screen tells the command to flip the screen at that exact time
    Screen('Flip', w, timing.show_fixation); %
    % however, matlab goes on executing code, so we also tell matlab to wait up
    wait_until(timing.show_fixation);
    
%% at the appropriate time, display the go signal

    stop1_draw_background(exp, w);
    if td.direction == 'left' %#ok<STCMP>
        draw_arrow(w, [exp.display.x_center exp.display.y_center], 0, exp.display.colors.green, [150 300 500 150])
    else
        draw_arrow(w, [exp.display.x_center exp.display.y_center], 180, exp.display.colors.green, [150 300 500 150])
    end
     [~,td.go_signal_time]= Screen('Flip', w, timing.go_signal); % 3rd arg = flip time
    wait_until(timing.go_signal);
    %send cue for go signal
    
    
%% setup variables to get response

    keep_checking = true;
    screen_has_not_been_cleared = true;
    left_has_responded = false;
    right_has_responded = false;
    left_rt = NaN;
    right_rt = NaN;
    if td.trial_type == 'stop' %#ok<STCMP>
        is_stop_trial = true;
        stop_signal_pending = true;
        stop1_audio_prep_stop_signal(exp);
    else
        is_stop_trial = false;
        stop_signal_pending = false;
    end

    % supress keyboard output (unless in debug mode, because it makes it difficult to recover from errors)
    if ~exp.debug
        ListenChar(2);
    end


%% query for responses, and display stop signal if/when applicable
    

	try

        while keep_checking

            % KbCheck using only main keyboard
            if IsOSX
                if exp.mouse == 0
                    if exp.keypad == 0
                [key_was_pressed, press_time, key_list] = PsychHID('KbCheck', exp.keyboard.main_keyboard_index);
                    else
                         [key_was_pressed, press_time, key_list] = PsychHID('KbCheck', exp.keyboard.keypad_index);
                    end
                else
                    [~, ~, response_time, button1_press,button2_press,button3_press] = get_mouse_click_button_out_nicki(w, exp.limited_hold, [], 1);
                    if button1_press
                        key_was_pressed = 1;
                        button_press = 1;
                    elseif button2_press
                        key_was_pressed = 1;
                        button_press = 2;
                    elseif button3_press
                        key_was_pressed = 1;
                        button_press = 3;
                        
                        
                    else
                        key_was_pressed = 0;
                    end
                end
            else
                [key_was_pressed, press_time, key_list] = KbCheck();
            end
            
            if key_was_pressed
                if exp.mouse == 0
                    if isnan(left_rt)  && key_list(exp.keyboard.left_key),  left_rt  = press_time; left_has_responded  = true; end;
                    if isnan(right_rt) && key_list(exp.keyboard.right_key), right_rt = press_time; right_has_responded = true; end;
                else
                    if td.direction == 'left'&& button_press == exp.keyboard.left_key
                        left_rt = response_time;
                        left_has_responded = true;
                    elseif td.direction == 'right'&& button_press == exp.keyboard.right_key
                        right_rt = response_time;
                       right_has_responded = true;
                   end
               end
                       
                       
            end
%                     if isnan(left_rt)  && key_list(exp.keyboard.left_key),  left_rt  = press_time; left_has_responded  = true;
%                     elseif isnan(right_rt) && key_list(exp.keyboard.right_key), right_rt = press_time; right_has_responded = true; 

            % when the subject makes a response, clear the screen to give some feedback
            if screen_has_not_been_cleared && (left_has_responded || right_has_responded)
                stop1_draw_background(exp, w);
                Screen('Flip', w);
                screen_has_not_been_cleared = false;
            end

            % play stop signal if this is a stop trial and the time has come
            if stop_signal_pending && GetSecs > timing.stop_signal
                
                % Get the size of the on screen window
                [screenXpixels, screenYpixels] = Screen('WindowSize', w);

                % Get the centre coordinate of the window
                [xCenter, yCenter] = RectCenter([0,0,exp.display.width,exp.display.height]);
                % Number of sides for our polygon
                numSides = 8;

                % Angles at which our polygon vertices endpoints will be. We start at zero
                % and then equally space vertex endpoints around the edge of a circle. The
                % polygon is then defined by sequentially joining these end points.
                anglesDeg = linspace(22.5, 382.5, numSides + 1);
                anglesRad = anglesDeg * (pi / 180);
                radius = 250; % previously 100

                % X and Y coordinates of the points defining out polygon, centred on the
                % centre of the screen
                yPosVector = sin(anglesRad) .* radius + yCenter+(pi/4);
                xPosVector = cos(anglesRad) .* radius + xCenter+(pi/4);
                isConvex = 1;

                % Draw the rect to the screen
                Screen('FillPoly', w, exp.display.colors.red, [xPosVector; yPosVector]', isConvex);
                
                [~,td.stop_signal_time] = Screen('Flip', w, timing.stop_signal); % 3rd arg = flip time
                wait_until(timing.stop_signal);
                
                %stop1_audio_play_stop_signal(exp);
               % td.stop_signal_time = GetSecs;
                stop_signal_pending = false;
            end
% always wait until the end of the limited hold period (per Nicki 8/23/09)

           if GetSecs > timing.limited_hold_end
                keep_checking = false;
                if screen_has_not_been_cleared
                    stop1_draw_background(exp, w);
                    Screen('Flip', w);
                end
            end

        end
        
    catch
        ListenChar(0);  %starts listening to keyboard, clears everything if there is an error
        
        cls
        rethrow(lasterror);
    end
    
    % start listening to the keyboard again
    ListenChar(0);

%% save reaction times (adjusted for when the go signal was given)

    td.button_press_time = min(left_rt, right_rt);
    td.left_rt = left_rt - timing.go_signal;
    td.right_rt = right_rt - timing.go_signal;
    
end
