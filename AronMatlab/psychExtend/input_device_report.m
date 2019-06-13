function [device_list] = input_device_report(show_in_command_prompt)
% Displays a report of which input devices are connected and active
%
% [device_list] = input_device_report([show_in_command_prompt])
%   If input_device_report is passed the optional show_in_command_prompt argument,
%   it returns the device_list in the command window
% 

% Written by mikeclaffey@yahoo.com
% Last updated: April 23 2008
%
        
    if ~exist('show_in_command_prompt', 'var'), show_in_command_prompt = false; end;

%% command prompt version
    if show_in_command_prompt
        while true
            clc
            device_list = input_device_list(true);
            display(device_list);
            active_devices = input_device_find('', true);
            if isempty(active_devices)
                fprintf('\nNo active devices (press key or mouse button)\n\n');
            else
                fprintf('\nActive devices: %s \n\n', mat2str(active_devices));
            end
            fprintf('Press Command-. to exit\n');
            pause(.3);
        end            
    
%% PsychToolbox screen version
    else
        % keep querying and displaying the input devices until an
        % escape key is pressed
        kb = input_device_keyboard;
        screen_pointer = display_screen_text('', [], 'no flip');
        while ~get_key_press(kb, 0.2, {'escape'})
            device_list = input_device_list(true);

            % build the on screen text
            device_text={};
            for line = 1:size(device_list, 1)
                device_text(line) = { sprintf('%d) %s (%s) - %s', ...
                                        device_list.index{line}, ...
                                        device_list.product{line}, ...
                                        char(device_list.type_short(line)), ...
                                        device_list.active_desc{line} ...
                                        ) }; %#ok<AGROW>
            end

            device_text{end + 1} = '(Remember, you must plug in a device before starting MATLAB for it to register)'; %#ok<AGROW>
            device_text{end + 1} = 'Press ESCAPE to exit'; %#ok<AGROW>
            display_screen_text(device_text, screen_pointer, 'no wait', 16)
        end
        clear Screen
    end
end



