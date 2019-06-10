%modified by Nicki Swann 4/23/09 for standard stop
% The main script that iterates through trial_data. Written as a script as opposed to a function
% because variables
% are being updated in the global workspace. if an error occurs, the experiment can continue where it left off,
% (possibly losing data from the current trial with the error). If this routine is changed to a function,
% I should include a line to save the variables to the global workspace with each iteration.

%%
exp.is_practice = false;

%% setup the screen
try
    w = scr();
catch
    fprintf('PsychToolbox failed to open a screen (see details above). Just try running again...\n')
    return
end

%%set up buttons if using mouse
    if exp.mouse ==1
     fprintf('Press mouse key for left response:... ');
         [~, ~, response_time, button1_press,button2_press,button3_press] = get_mouse_click_button_out_nicki(w, 1, [], 1);
         if button1_press
         exp.keyboard.left_key = 1;
         elseif button2_press
              exp.keyboard.left_key = 1;
         elseif button3_press
              exp.keyboard.left_key = 3;
         end
         
         
         fprintf('Press mouse key for right response:... ');
         [~, ~, response_time, button1_press,button2_press,button3_press] = get_mouse_click_button_out_nicki(w, 1, [], 1);
         if button1_press
         exp.keyboard.right_key = 1;
         elseif button2_press
              exp.keyboard.right_key = 1;
         elseif button3_press
              exp.keyboard.right_key = 3;
         end
    end

%% iterate until all lines have been completed
while any(~trial_data.complete)
    
    % find first incomplete trial
    exp.current_trial = find(~trial_data.complete, 1, 'first');
        
    % take any needed action at the beginning of a new block
    if exp.current_trial == 1 || trial_data.block(exp.current_trial) ~= trial_data.block(exp.current_trial-1)
        [exp, trial_data] = stop1_block_start(exp, trial_data, w);
    end
    
    % actual trial - get response and process
    [exp, trial_data] = stop1_trial(exp, trial_data, w);
    
    % save after each trial
    save(exp.behav_file, 'exp', 'trial_data')
    
    % provide feedback before transition to bext block and on last trial
    if exp.current_trial == size(trial_data,1) || trial_data.block(exp.current_trial) ~= trial_data.block(exp.current_trial+1)
        [exp, trial_data] = stop1_block_end(exp, trial_data, w);
        
    % every 18 trials (except block ends), wive subjects a rest    
    elseif mod(exp.current_trial, 24) == 0
        stop1_block_interim_rest(exp, trial_data, w);
    end


end

%%
cls
fprintf('Experiment complete!\n')
