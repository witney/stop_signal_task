function [trial_order] = scramble_groups_of_trials(trial_count, group_size)
% [trial_order] = scramble_groups_of_trials(trial_count, group_size)    
       
        group_count = trial_count / group_size;
        assert(mod(group_count,1)==0, 'TRIAL_COUNT must be a multiple of GROUP_SIZE');
        
        group_order = randperm(group_count)';
        trial_order = expandmat(group_order, group_size) .* group_size - repmat([(group_size-1):-1:0]',group_count,1);
    
end