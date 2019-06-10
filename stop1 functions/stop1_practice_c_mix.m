function [exp] = stop1_practice_c_mix(exp)

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
            'no_stop'              'go'          'left'      ; ...
            'no_stop'              'go'          'right'     ; ...
            'no_stop'              'go'          'left'      ; ...
            'no_stop'              'go'          'right'     ; ...
            'maybe_stop'           'go'          'left'      ; ...
            'maybe_stop'           'go'          'right'     ; ...
            'maybe_stop'           'stop'        'left'      ; ...
            'maybe_stop'           'stop'        'right'     ; ...
            };
            
    % repeat the matrix to reach the necessary number of trials per block
    practice_data = repmat(practice_data, 5, 1);
        
    % randomize the entire block
    practice_data = randperm_chop(practice_data);
        
    % convert practice_data to a dataset and finalize
    practice_data = dataset({practice_data, 'cue', 'trial_type', 'direction' } );
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

    assignin('base', 'practice_data', practice_data);
    practice_stats = dataset_grpmean(practice_data, {'cue', 'trial_type'}, {'left_rt', 'right_rt', 'rt', 'correct'});
    
    % calculate stopping statistics
    stop_data = practice_data(practice_data.trial_type=='stop', :);
    [ssd, ssd_stats] = ssd_analyzer(stop_data.ssd, stop_data.correct, 'ssrt_method', '50 percent');
    practice_stats = dataset_add_columns(practice_stats, {'ssd', 'ssrt'});
    practice_stats{'maybe_stop_stop', 'ssd'} = ssd;
    practice_stats.ssrt = practice_stats.rt - practice_stats.ssd;
    
    % calculate starting ssd
    median_rt = nanmedian(practice_data.rt(practice_data.cue == 'maybe_stop' & practice_data.trial_type=='go' & practice_data.correct == 1));
    starting_ssd = median_rt - .2;
    starting_ssd = round(starting_ssd / exp.parameters.staircase_increment) * exp.parameters.staircase_increment;
    
    % display and save
    disp(practice_stats);
    exp.practice.maybe_stop = practice_stats;
    
%% prompt for starting ssd

    fprintf('Suggested starting SSD is %1.3f secs\n', starting_ssd);
    prompt_starting_ssd = input('Use what starting SSD? (ENTER for suggested): ');
    if ~isempty(prompt_starting_ssd), starting_ssd = prompt_starting_ssd; end;
    exp.parameters.staircase_values(:) = starting_ssd;

end
