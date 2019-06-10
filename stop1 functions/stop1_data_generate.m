%%modified by Nicki Swann 4/22/09 for standard stopping
function [exp, trial_data] = stop1_data_generate(exp)
% Generate trial_data for experiment
    
%% needed columns:

    % for performing the trial itself
        %   trial_type (go vs stop)
        %   direction (left vs right)
        %   staircase index (1, 2)
        %   ssd (added at the time of trial based on current staircase values)

    % general tracking values
        % subject id
        % block number
        % trial number
                
    % needed for experiment framework
        % start time (the GetSecs when the trial starts)
        % duration (GetSecs when the trial ends minus start time)
        % complete (true or false)
        % time when go cue came up
        % time beep was played
        
    
    
%% setup parameters
    
    trial_data = [];

    exp.parameters.block_count = 3;
    exp.parameters.trials_per_block = 96;
           
%% seed random generator
    rand('state', exp.subject_id);
    
    
%% generate data for each block

    for block = 1:exp.parameters.block_count       

        % start with a line for every variation of trial
        block_data = {
                    'go'        'left'      ; ...
                    'go'        'right'     ; ...
                    'go'        'left'      ; ...
                    'go'        'right'     ; ...
                    'stop'      'left'      ; ...
                    'stop'      'right'     ; ...
            
            };  %go trials are doubled b/c they have higher frequency, this will give 33% stops
            
        % repeat the matrix to reach the necessary number of trials per block
        needed_replications = exp.parameters.trials_per_block / size(block_data, 1);
        block_data = repmat(block_data, needed_replications, 1);
        
        % randomize the entire block
        block_data = randperm_chop(block_data);
        
        % convert block_data to a dataset and fix trial types
        block_data = dataset({block_data, 'trial_type', 'direction' } );
        block_data = dataset_nominalize_fields(block_data, {'trial_type', 'direction'});
                
        % add a column for the block number
        block_data = dataset_add_columns(block_data, 'block', block);
        
        % append to trial_data
        trial_data = dataset_append(trial_data, block_data);
    end
        
%% final formatting

    [trial_data] = stop1_data_format(exp, trial_data);
    
end