%%modified by Nicki Swann 4/22/09 for standard stopping
function [trial_data] = stop1_data_format(exp, trial_data)

    
%STOP1_DATA_FORMAT Add all necessary columns, change column format and order

    % for performing the trial itself
        %   trial_type (go vs stop)
        %   direction (left vs right)
        %   block number
        
%% columns added by this function       

    % for performing the trial itself
        %   staircase index (1, 2)
        %   ssd (added at the time of trial based on current staircase values)

    % general tracking values
        % subject id
        % trial number
                
    % needed for experiment framework
        % start time (the GetSecs when the trial starts)
        % duration (GetSecs when the trial ends minus start time)
        % complete (true or false)
        
%% column reordering        
        
    % this cell array determines the order of the columns in the trial_data dataset
    % if this list doesn't match exactly with the final columns in trial_data, an error is thrown
    column_order = { ...
        'subject', ...
        'block', ...
        'trial_num', ...
        'trial_type', ...
        'direction', ...
        'start_time', ...
        'stop_signal_time', ...
        'go_signal_time', ...
        'button_press_time', ...
        'duration', ...
        'complete', ...
        'staircase', ...
        'staircase_mode', ...
        'ssd', ...
        'left_rt', ...
        'right_rt', ...
        'rt', ...
        'outcome', ...
        'correct' ...
        };


        
%% fix columns

    % clean up column types & add remaining columns
    trial_data = dataset_nominalize_fields(trial_data, {'trial_type', 'direction'});
    trial_data.trial_num = [1:size(trial_data,1)]'; %#ok<NBRAK>
    trial_data = dataset_add_columns(trial_data, 'subject', exp.subject_id, 'start_time', NaN, 'duration', NaN, 'complete', 0);
    
    % add staircase value and placeholder column for ssd
    trial_data = dataset_add_columns(trial_data, 'staircase', NaN, 'ssd', NaN, 'staircase_mode', '');
    trial_data = dataset_nominalize_fields(trial_data, 'staircase_mode');    
    left_stops = trial_data.trial_type=='stop' & trial_data.direction=='left';
    if any(left_stops)
%         trial_data.staircase(left_stops) = randperm_chop(repmat([1;2;3], ceil(sum(left_stops)/3), 1), sum(left_stops));
        trial_data.staircase(left_stops) = randperm_chop(repmat([1], ceil(sum(left_stops)/1), 1), sum(left_stops));
    end
    right_stops = trial_data.trial_type=='stop' & trial_data.direction=='right';
    if any(right_stops)
%         trial_data.staircase(right_stops) = randperm_chop(repmat([4;5;6], ceil(sum(right_stops)/3), 1), sum(right_stops));
        trial_data.staircase(right_stops) = randperm_chop(repmat([2], ceil(sum(right_stops)/1), 1), sum(right_stops));    
    end
    
    % add columns for reaction time values and outcome
    trial_data = dataset_add_columns(trial_data, 'left_rt', NaN, 'right_rt', NaN, 'rt', NaN, 'outcome', 'incomplete', 'correct', NaN);
    trial_data = dataset_add_columns(trial_data, 'stop_signal_time', NaN, 'go_signal_time', NaN, 'button_press_time', NaN);
    % trial_data = dataset_add_columns(trial_data, 'jitter', NaN);
    trial_data = dataset_nominalize_fields(trial_data, 'outcome');
    
%% redorder columns

    missing_fields = setxor(get(trial_data, 'VarNames'), column_order);
    if ~isempty(missing_fields)
        fprintf('Bad fields:\n');
        disp(missing_fields)
        error('The above columns are not handled properly in the column reording process')
    end    
    trial_data = trial_data(:, column_order);
    
end
