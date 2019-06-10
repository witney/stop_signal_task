function [exp] = stop1_practice_b_stopping(exp)

    w = scr;
    exp.is_practice = true;

  
%% prompt subject

    stop1_draw_background(exp, w);
    DrawFormattedText(w, 'This practice will have 20 trials\n\nwith both "Maybe Stop" and "No Stop"\n\n(press spacebar to start)', 'center', 'center');
    Screen('Flip', w);

get_key_press(exp.keyboard.main_keyboard_index, 0, {'space'}, true)
    Screen('Flip',w);
    
    
%% generate data    
    
    practice_data = {
                       'go'          'left'      ; ...
                       'go'          'right'     ; ...
                       'stop'        'left'      ; ...
                       'stop'        'right'     ; ...
            };
            
    % repeat the matrix to reach the necessary number of trials per block
    practice_data = repmat(practice_data, 5, 1);
        
    % convert practice_data to a dataset and finalize
    practice_data = dataset({practice_data, 'trial_type', 'direction' } );
    practice_data = dataset_add_columns(practice_data, 'block', 1);
    [practice_data] = stop1_data_format(exp, practice_data);

    % randomize the entire block
    practice_data = randperm_chop(practice_data);
    % keep scrambling if there are more than 2 stop trials in a row
    sufficiently_scrambled = false;
    while ~sufficiently_scrambled
        practice_data = randperm_chop(practice_data);
        [streak_start, streak_length] = find_longest_streak(practice_data.trial_type=='stop');
        if streak_length <= 2, sufficiently_scrambled = true; end
    end
        

%% iterate through practice    

    for trial = 1:size(practice_data, 1)
        exp.current_trial = trial;
        [exp, practice_data] = stop1_trial(exp, practice_data, w);
    end
    
%% clear screen

    cls

%% record and display results

    assignin('base', 'practice_data', practice_data);
    practice_stats = dataset_grpmean(practice_data, 'trial_type', {'left_rt', 'right_rt', 'correct'});
    disp(practice_stats);
    exp.practice.maybe_stop = practice_stats;
    

