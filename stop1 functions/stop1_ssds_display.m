function [exp] = stop1_ssds_display(exp)
% Display current staircase settings in command window    

    fprintf('--- SSD Staircase settings (seconds) ---------------\n')
    if strcmpi(exp.parameters.staircase_mode, 'tracking')
        fprintf('Staircase mode: Using dynamic tracking with one value each for left and right stopping\n');
        fprintf('\tCurrent staircase left value:    %1.3f\n', exp.parameters.staircase_values(1));
        fprintf('\tCurrent staircase right value:   %1.3f\n', exp.parameters.staircase_values(4));
        fprintf('\tCurrent staircase increment:     %1.3f\n', exp.parameters.staircase_increment);
        fprintf('\tCurrent staircase minimum:       %1.3f\n', exp.parameters.staircase_minimum);
    else
        fprintf('Staircase mode: Fixed SSDs with three values (same for both left and right stopping)\n');
        fprintf('\tCurrent staircase value 1:    %1.3f\n', exp.parameters.staircase_values(1));
        fprintf('\tCurrent staircase value 2:    %1.3f\n', exp.parameters.staircase_values(2));
        fprintf('\tCurrent staircase value 3:    %1.3f\n', exp.parameters.staircase_values(3));        
    end
    
end


    