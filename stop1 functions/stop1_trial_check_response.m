%%modified  4/23/09 by Nicki Swann for standard stopping
function [exp, td] = stop1_trial_check_response(exp, td, w, timing)
% Check outcome of subject response and adjust SSD (if applicable)
    
    left_responded = ~isnan(td.left_rt);
    right_responded = ~isnan(td.right_rt);
    
%% outcomes for go trials
    if td.trial_type == 'go'
        if ~left_responded && ~right_responded
            td.correct = 0;
            td.outcome = 'go - no response';
        elseif min(td.left_rt, td.right_rt) > 2
            td.correct = 0;
            td.outcome = 'go - too slow';
        elseif td.direction == 'left' && left_responded && ~right_responded
            td.outcome = 'go - correct';
            td.correct = 1;
            td.rt = td.left_rt;
        elseif td.direction == 'right' && ~left_responded && right_responded
            td.outcome = 'go - correct';
            td.correct = 1;
            td.rt = td.right_rt;
        else
            td.correct = 0;
            td.outcome = 'go - misc error';
        end
        
        td.outcome = nominal(td.outcome);

        
%% outcomes for stop trials
    else
        if td.left_rt < td.ssd || td.right_rt < td.ssd
            td.correct = 1;
            td.outcome = 'stop - response before ssd';        
        elseif ~left_responded && ~right_responded
            td.correct = 1;
            td.outcome = 'stop - correct';
        elseif td.direction == 'left' && left_responded && ~right_responded
            td.outcome = 'stop - failed stop';
            td.correct = 0;
            td.rt = td.left_rt;
        elseif td.direction == 'right' && ~left_responded && right_responded
            td.outcome = 'stop - failed stop';
            td.correct = 0;
            td.rt = td.right_rt;
        else
            td.correct = 0;
            td.outcome = 'stop - misc error';
        end

        td.outcome = nominal(td.outcome);

%% adjust ssds

        current_ssd = td.ssd;
        if td.correct && td.outcome ~= 'stop - response before ssd'
            % increase the next ssd, making it more difficult
            new_ssd = current_ssd + exp.parameters.staircase_increment;
        else
            % decrease the next ssd, making it easier
            new_ssd = current_ssd - exp.parameters.staircase_increment;
            % dont let the ssd get below a minimum
            if new_ssd < exp.parameters.staircase_minimum, new_ssd = exp.parameters.staircase_minimum; end;
        end
        
        if strcmpi(exp.parameters.staircase_mode, 'tracking')
            if td.staircase <= 3
                exp.parameters.staircase_values(1:3) = new_ssd;
            else
                exp.parameters.staircase_values(4:6) = new_ssd;
            end                
            
        elseif strcmpi(exp.parameters.staircase_mode, 'fixed')
            % do nothing, SSDs are fixed            
        else
            error('Unrecognized SSD tracking mode');
        end
            
    end

%% record staircase tracking mode
    td.staircase_mode = nominal(exp.parameters.staircase_mode);
    
    
end