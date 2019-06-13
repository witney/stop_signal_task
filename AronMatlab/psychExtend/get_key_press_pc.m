function [varargout] = get_key_press_pc(keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down)
% Waits for user input from keyboard with customizable options
%
% get_key_press is based on the KbCheck function, but provides a variety of options such as
% enforcing a maximum wait time and checking for only certain keys
%
% [key_was_pressed, wait_time, list_of_pressed_keys] = get_key_press(keyboard_pointer, max_wait_in_secs, valid_key_list, wait_if_already_down)
%
%   keyboard_pointer = (optional integer array) device index of which input
%       device to check. 0 checks the default keyboard. multiple device indices
%       can be specified to cycle through multiple keyboards.
%   max_wait_in_secs = (optional integer) if max_wait_in_secs > 0, returns null if user
%       doesn't respond in time. If max_wait_in_secs is empty or = 0, there is no time limit. If
%       max_wait_in_secs is < 0, it just a single kbcheck.
%   valid_key_list = (optional cell array) if not empty, only stops checking
%       when a key in the list is pressed (e.i. {'Z' 'Space' 'M'})
%   wait_if_already_down = (optional integer) if not 0, will wait to
%       start checking until any currently pressed keys are released
%       (defaults to 0)
%
% Example:
%   get_key_press()
%
%       The function without any arguments is essentially equivalent to KbCheck
%
%   get_key_press(0, 2, {'z', 'space', 'm'}, 1)
%
%       The above command checks the default keyboard for only the 'Z', 'M' and Space key. It ignores
%       any other pressed keys. It will wait for up to 2 seconds for a valid key to be pressed,
%       otherwise it returns key_was_pressed = 0.

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)

% 02/18/09 fix so that a negative max_wait_in_secs does at least one KbCheck
% 02/18/09 allow get_key_press to be used in an if statement (nargin=0)
% 02/18/09 allow valid_key_list to be passed as a string
% 02/12/09 functionality of checking multiple keyboards
% 02/10/09 corrected empty value for max_wait_in_secs to be adjusted to zero
% 09/17/08 Cleaned up help
% 04/23/08 Previous version

%% setup function variables

    start_time = GetSecs;
%     if ~exist('keyboard_pointer', 'var') || isempty(keyboard_pointer) && isOSX
%         try
%             keyboard_pointer = input_device_keyboard;
%         catch
%             error('get_key_press:couldnt_find_keyboard', 'Input device wasn''t specified and could not find keyboard automatically');
%         end
%     end
%     
    if ~exist('max_wait_in_secs', 'var') || isempty(max_wait_in_secs)
        max_wait_in_secs = 0;
    else
        end_wait_time = GetSecs + max_wait_in_secs;
    end
    
    if ~exist('valid_key_list', 'var')
        valid_key_list = [];
    else
        if ischar(valid_key_list), valid_key_list = {valid_key_list}; end;
        for x = 1:length(valid_key_list)
            try
                if not(isnumeric(valid_key_list{x}))
                    valid_key_list(x) = {KbName(valid_key_list{x})};
                end
            catch
                error('Item %d in the valid_key_list array is not recognizable', x)
            end
        end
        % now convert it to a matrix
        valid_key_list = cell2num(valid_key_list);
    end;
    
    if ~exist('wait_if_already_down', 'var'), wait_if_already_down = 1; end;
    if nargin > 4, error('Too many arguments supplied to get_key_press'); end;
    
    KeyIsDown = 0;
    list_of_pressed_keys = [];
    
%% wait for keyboard response
    if wait_if_already_down % this variable is the optional arguement
        wait_for_unpressed_keyboard() % this is the actual name of the sub function
    end

    ListenChar(2);
    try
        while wait_time_hasnt_expired() && ~keypress_is_valid_key()
            [KeyIsDown, press_time, keyCode] = KbCheck_many_keyboards([]);
            list_of_pressed_keys = find(keyCode > 0);
            pause(0.001);
        end
    catch
        ListenChar(0);
        rethrow(lasterror);
    end
    ListenChar(0);
    
%% return results
    
    if nargout == 0
        % when get_key_press is a logical expression of an if statement
        %   for example: if get_key_press([], .001, 'escape') % evaluates to true if the escape is down
        varargout = {keypress_is_valid_key};
    else
        % otherwise build outputs and return the appropriate number of them
        key_was_pressed = keypress_is_valid_key;
        wait_time = GetSecs - start_time;
        varargout = {key_was_pressed, wait_time, list_of_pressed_keys};
        varargout = varargout(1:nargout);
    end


    
%% helper functions

    function [hasnt_expired] = wait_time_hasnt_expired()
       if max_wait_in_secs == 0
           hasnt_expired = 1;
       elseif max_wait_in_secs < 0
           hasnt_expired = 1;
           % change these variables so that it wont provide true next time
           max_wait_in_secs = 1;
           end_wait_time = GetSecs;
       else
           if GetSecs < end_wait_time
               hasnt_expired = 1;
           else
               hasnt_expired = 0;
           end
       end
    end

    function [valid_key] = keypress_is_valid_key()
        if ~KeyIsDown
            valid_key = 0;
        elseif isempty(valid_key_list)
            valid_key = 1;
        else
            if any(intersect(list_of_pressed_keys, valid_key_list))
                valid_key = 1;
            else
                valid_key = 0;
            end
        end
    end

    function wait_for_unpressed_keyboard
        KeyIsDown = 1;
        while KeyIsDown
            KeyIsDown = KbCheck_many_keyboards([]);
        end
    end

end
    