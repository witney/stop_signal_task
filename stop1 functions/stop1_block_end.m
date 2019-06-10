function [exp, trial_data] = stop1_block_end(exp, trial_data, w)    
    
    current_block = trial_data.block(exp.current_trial);
    [exp, trial_data] = stop1_block_feedback(exp, trial_data, w, current_block);
    
%%

    stop1_draw_background(exp, w);
    DrawFormattedText(w, 'press SPACE BAR to continue, ESCAPE to exit', 'center', 'center');
    Screen('Flip',w);

    % wait for keypress
    [was_pressed, press_time, keys] = get_key_press(exp.keyboard.main_keyboard_index, 0, {'space', 'escape'}, true);
    Screen('Flip',w);
    if ismember(41, keys) || ismember(27, keys) % check for escape (mac) and esc (pc)
        cls;
        error('Experiment stopped at end of block %d', current_block)
    end;
    
end
