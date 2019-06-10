function [exp, trial_data] = stop1_block_start(exp, trial_data, w)
% Run at the beginning of each block


    current_block = trial_data.block(exp.current_trial);

    stop1_draw_background(exp, w);
    screen_text = sprintf('Starting block %d\n\n(press Space to begin)', current_block);
    DrawFormattedText(w, screen_text, 'center', 'center');
    Screen('Flip',w);

    % wait for keypress
    get_key_press(exp.keyboard.main_keyboard_index, 0, {'space'}, true)
    Screen('Flip',w);

    
end
