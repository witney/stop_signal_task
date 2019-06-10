function [exp] = stop1_ssds_change(exp)
% Prompt user to change staircase settings    
    
    stop1_ssds_display(exp);
    
%% prompt for changes
    
    change_prompt = input('\nChange to what mode? (ENTER for no change, "t" for tracking, "f" for fixed): ', 's');
    if isempty(change_prompt), return; end;
    if ~(strcmpi(change_prompt, 't') || strcmpi(change_prompt, 'f'))
        fprintf('Unknown response, not making any changes to staircases\n');
        return
    end
    
    fprintf('\nAll values are in seconds (e.g. SSD = 0.200, increments = 0.050).)\n');

    
%% use tracking method

    if strcmpi(change_prompt, 't')
        
        % record tracking method
        exp.parameters.staircase_mode = 'tracking';
        
        % left ssd
        left_ssd = input('Use what SSD for left stopping? (ENTER for no change) ');
        if ~isempty(left_ssd), exp.parameters.staircase_values(1:3) = left_ssd; end;
        
        % right ssd
        right_ssd = input('Use what SSD for right stopping? (ENTER for no change) ');
        if ~isempty(right_ssd), exp.parameters.staircase_values(4:6) = right_ssd; end;
        
        % increment
        ssd_increment = input('Change SSD each time by how many seconds? (ENTER for no change) ');
        if ~isempty(ssd_increment), exp.parameters.staircase_increment = ssd_increment; end;
        
        % minimum
        ssd_minimum = input('Minimum SSD? (ENTER for no change) ');
        if ~isempty(ssd_minimum), exp.parameters.staircase_minimum = ssd_minimum; end;
    end

%% use fixed method

    if strcmpi(change_prompt, 'f')
        
        % record tracking method
        exp.parameters.staircase_mode = 'fixed';
        
        % get ssds
        ssds = input('Enter all three SSD values in matrix form (example: [0.1 0.2 0.3]) ');
        if isempty(ssds)
            fprintf('Using current values\n');
        else
            if all(eq(size(ssds), [1, 3]))
                exp.parameters.staircase_values(1:3) = ssds;
                exp.parameters.staircase_values(4:6) = ssds;
            else
                fprintf('SSDs not typed in correct format, not saving changes\n');
            end
        end
    end

%% display new settings
    stop1_ssds_display(exp);

    
end


    