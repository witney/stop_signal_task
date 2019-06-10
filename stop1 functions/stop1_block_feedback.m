function [exp, trial_data] = stop1_block_feedback(exp, trial_data, w, block)
% Display feedback graphs for block
    
    if isempty(w), w = scr; end;
    
%% annoying PC bug fix

    % there is an unresolveable bug on PCs that after the first Screen('Flip')
    % command, the get_key_press querying blanks the screen. The
    % cludgey fix is to flip a blank screen, do a meaningless
    % get_key_press, and then all subsequent screens will display ok
    % (mike c. 03-02-09)
    Screen('Flip',w);
    get_key_press(exp.keyboard.main_keyboard_index, -1, {'space'}, false);
    Screen('Flip',w);
    
%% calculate block stats and display in command window

    exp = stop1_block_stats(exp, trial_data);
    disp(exp.block_stats);

%% display message while graph is being generated

    stop1_draw_background(exp, w);
    %DrawFormattedText(w, 'Generating feedback graph...', 'center', 'center');
    Screen('Flip',w);

%% create graph for subject

%     if exp.debug
%         f_handle = figure('Visible','on');
%     else
%         f_handle = figure('Visible','off');
%     end
% 
%     block_count = max(exp.block_stats.block);
%     max_rt = nz(round_decimal(max(exp.block_stats.rt) + .1, 2), 1);
%     
%     % Reaction Time
%     subplot(2,1,1)
%     plot(exp.block_stats.block, exp.block_stats.rt, '-*b');
%     axis([0 (block_count+1) 0 max_rt]);
%     set(gca, 'XTick', [1:block_count], 'YTick', [0:.1:max_rt])
%     title('Reaction time');
%     xlabel('Block');
%     ylabel('Reaction time (secs)');
% 
%     % Go Accuracy
%     subplot(2,1,2)
%     plot(exp.block_stats.block, exp.block_stats.go_accuracy, '-*r');
%     axis([0 (block_count+1) 0 100]);
%     set(gca, 'XTick', [1:block_count], 'YTick', [0:20:100])
%     title('Accuracy of going with correct fingers');
%     xlabel('Block');
%     ylabel('% Accuracy');
% 
% 
% 
% %% display subject graph on screen
% 
%     stop1_draw_background(exp, w);
%     figure_to_ptb_screen(f_handle, w);
%     close(f_handle);
%     DrawFormattedText(w, 'press SPACE BAR to advance', 'center');
%     Screen('Flip',w);
% 
%     % wait for keypress
%     pause(2)
%     get_key_press(exp.keyboard.main_keyboard_index, 0, {'space'}, true);
%     Screen('Flip',w);
%     
% %% display message while graph is being generated
% 
%     stop1_draw_background(exp, w);
%     DrawFormattedText(w, 'Generating feedback graph...', 'center', 'center');
%     Screen('Flip',w);
% 
% %% create graph for experimenter
% 
%     if exp.debug
%         f_handle = figure('Visible','on');
%     else
%         f_handle = figure('Visible','off');
%     end
% 
%     % Plot 1 - Stopping probability
%     ax(1) = subplot(2,1,1);
%     %ssd_graph_stop_prob(exp.block_stats.ssd_data{block}, 'axis_handle', ax(1));
%     
%     % Plot 2 - Go RT & SSD Staircases by Trial
%     ax(2) = subplot(2,1,2);
%     stop_data = exp.block_stats.staircase_progression{block};
%     go_data = exp.block_stats.go_rt_progression{block};
%     ssd_graph_staircase(stop_data.ssd, ...
%         'axis_handle', ax(2), ...
%         'staircases', stop_data.staircase, ...
%         'stop_trial_nums', stop_data.trial_num, ...
%         'go_rts', go_data.rt, ...
%         'go_trial_nums', go_data.trial_num);
% 
% 
% %% display experimenter graph on screen
% 
%     stop1_draw_background(exp, w);
%     figure_to_ptb_screen(f_handle, w);
%     close(f_handle);
    DrawFormattedText(w, 'press SPACE BAR to advance', 'center');
    Screen('Flip',w);

    % wait for keypress
    get_key_press(exp.keyboard.main_keyboard_index, 0, {'space'}, true);
    Screen('Flip',w);
    
end
