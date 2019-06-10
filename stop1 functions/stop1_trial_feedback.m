function [exp, td] = stop1_trial_feedback(exp, td, w, timing)
% Display feedback in command window or screen after each trial (used for practice)
    
    % don't provide any trial-by-trial feedback in this version
    return

    response_outcome = char(td.outcome);

%% feedback on screen
        
    % During practice, show trial outcome for .5 second
    if exp.is_practice
        stop1_draw_background(exp, w);
        DrawFormattedText(w, response_outcome, 'center', 'center');
        Screen('Flip', w);
        pause(.5);
    end

    
%% debug mode shows extra details    
    if exp.debug
        trial_feedback = sprintf('RTs: %1.3f \n SSD: %1.3f\n%s', td.rt, td.ssd, response_outcome);
        fprintf('Trial %d: %s\n', nz(exp.current_trial, 0), sprintf(strrep(trial_feedback, char(10), '\t\t'))) % char(10) is newline        
        DrawFormattedText(w, trial_feedback, 'center', 'center');
        Screen('Flip', w);
        pause(.1);
        while ~KbCheck(exp.keyboard.main_keyboard_index), pause(.1); end;
        Screen('Flip', w);
    end


end

