%%modified on 4/23/09 by Nicki Swann for standard stopping.  
function [exp, trial_data] = stop1_trial(exp, trial_data, w)
% Runs all necessary actions for a single trial (also used for practice trials)

%% if the escape key is down, halt execution

    if get_key_press(exp.keyboard.main_keyboard_index, -1, exp.keyboard.quit_key, false)
        clear Screen
        error('Experiment stopped at trial %d.\n', exp.current_trial)
    end
    
%% create a variable containing only the current trial, for easy referencing in code

    td = trial_data(exp.current_trial, :);

%% send TTL pulse for ecog

    % this has been placed directly after the command that records the beginning of the trial in
    % order to maximize the coincidence of the td.start_time variable and the actual ecog trigger
     % stop1_action_send_TTL_pulse(exp);   
    stop1_audio_play_stop_signal(exp);
    trial_start_time = GetSecs;
  
    
%     %% find jitter for each ITI
% jitter_choices = [0 .1 .2 .3 .4];
% index_for_jitter = randperm(5);
% jitter = jitter_choices(index_for_jitter(1));
% td.jitter = jitter;
%% determine timing

    timing = struct('start', trial_start_time);  %MODIFY THESE TIMES DEPENDING ON STANDARD STOPPING
    timing.show_fixation = timing.start + .5;
    timing.go_signal = timing.show_fixation + .5;
    exp.limited_hold = 1.5;
    timing.limited_hold_end = timing.go_signal + exp.limited_hold;

%% determine ssd (for stop trials)    
    
    % if there is a staircase index, determine the value dynamically
    if ~isnan(td.staircase)
        td.ssd = exp.parameters.staircase_values(td.staircase);
    end
    timing.stop_signal = timing.go_signal + td.ssd; % this will be NaN for go trials


    
%% the three horsemen of the trial

    [exp, td] = stop1_trial_get_response(exp, td, w, timing);
    [exp, td] = stop1_trial_check_response(exp, td, w, timing);
    [exp, td] = stop1_trial_feedback(exp, td, w, timing);


%% end trial

    td.start_time = timing.start;
    td.duration = nz(GetSecs - timing.start, 0);
    td.complete = 1;

%% save the td variable back into trial data

    % useful for debugging, but not necessary for functioning
    assignin('base', 'td', td)

    old_warnings = warning('off', 'stats:categorical:subsasgn:NewLevelsAdded');
    trial_data(exp.current_trial, :) = td;
    warning(old_warnings);
    
%% display last 10 trials in command line for checking status

    disp(trial_data(max(1, exp.current_trial-9):exp.current_trial, :));
    
end
