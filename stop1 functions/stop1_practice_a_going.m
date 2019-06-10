%%modified 4/28/09 by Nicki Swann for standard stopping
function [exp] = stop1_practice_a_going(exp)

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
                       'go'        'left'      ; ...
                       'go'        'right'     ; ...
            };
            
    % repeat the matrix to reach the necessary number of trials per block
    practice_data = repmat(practice_data, 5, 1);
        
    % randomize the entire block
    practice_data = randperm_chop(practice_data);
        
    % convert practice_data to a dataset and finalize
    practice_data = dataset({practice_data, 'trial_type', 'direction' } );
    practice_data = dataset_add_columns(practice_data, 'block', 1);
    [practice_data] = stop1_data_format(exp, practice_data);

%% iterate through practice    

    for trial = 1:size(practice_data, 1)
        exp.current_trial = trial;
        [exp, practice_data] = stop1_trial(exp, practice_data, w);
    end
    
%% clear screen
    
    cls

%% record and display results

    practice_stats = dataset_grpmean(practice_data, 'trial_type', {'left_rt', 'right_rt', 'correct'});
    disp(practice_stats);
    exp.practice.go = practice_stats;
    

