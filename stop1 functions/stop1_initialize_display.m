function [exp, w] = stop1_initialize_display(exp)

%STOP1_INITIALIZE_DISPLAY Test the screen and save the basic parameters returned by scr()    
    
    [w, sp] = scr();
    exp.display = sp;
    stop1_draw_background(exp, w)
    DrawFormattedText(w, 'Screen works...', 'center', 'center', sp.colors.white);
    Screen('Flip', w);
    pause(.5);
    cls

%% calculate stimuli coordinates

    % this is a good place to calculate the coordinates of all stimuli to be displayed on the screen
    % throughout the experiment. This eliminates repitious calculations that would be performed
    % during each trial and can also identify potential display errors (e.g. the screen is not big
    % enough for the stimuli as programmed) before the experiment starts.

end
