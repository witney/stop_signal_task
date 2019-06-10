function [exp] = stop1_ssds_initialize(exp)
% Set change mode and default values for staircases    
    
    if ~isfield(exp, 'parameters'), exp.parameters = []; end;
    if ~isfield(exp.parameters, 'staircase_values')
        exp.parameters.staircase_mode = 'tracking';
        exp.parameters.staircase_values = repmat(.15, 1, 2);
%         exp.parameters.staircase_labels = {'left_1', 'left_2', 'left_3', 'right_4', 'right_5', 'right_6'};
        exp.parameters.staircase_labels = {'left_1','right_1'};
    exp.parameters.staircase_increment = 0.050;
        exp.parameters.staircase_minimum = 0.050;
        return
    end
    
end


    