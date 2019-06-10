function [exp] = stop1_initialize_inputs(exp)
%STOP1_INITIALIZE_INPUTS Finds input devices and confirms keys being used
    
    if IsOSX
%         exp.keyboard.main_keyboard_index = input_device_by_prompt('Please press any key on the main keyboard\n', 'keyboard');
         exp.keyboard.main_keyboard_index = [];%input_device_by_prompt('Please press any key on the main keyboard\n', 'keyboard');
        exp.keyboard.quit_key = 'escape';
    else
        % PC's don't need a keyboard index
        exp.keyboard.main_keyboard_index = [];
        exp.keyboard.quit_key = 'esc';
    end

    
%% determine which keys to use for responses    
    if exp.debug || isempty(input('Use default keys? (ENTER for ''z'' and ''/?'', type ''n'' to customize keys): ', 's'))
        exp.keyboard.reponse_keys = {'z' '/?'};
        exp.keyboard.left_key = KbName(exp.keyboard.reponse_keys{1});
        exp.keyboard.right_key = KbName(exp.keyboard.reponse_keys{2});
        exp.mouse = 0;
        exp.keypad = 0;
    else
        
        if isempty(input('do you want to use the mouse? ENTER for no, n for yes','s'))
            if isempty(input('do you want to use the keypad? ENTER for no, n for yes','s'))
                exp.mouse = 0;
                exp.keypad = 0;
                fprintf('Press key for left response:... ');
                [was_pressed, press_time, pressed_key] = get_key_press(exp.keyboard.main_keyboard_index, [], {}, true);
                exp.keyboard.left_key = pressed_key(1);
                exp.keyboard.reponse_keys{1} = KbName(exp.keyboard.left_key);
                fprintf('key = ''%s''\n', exp.keyboard.reponse_keys{1});
                
                fprintf('Press key for right response:... ');
                [was_pressed, press_time, pressed_key] = get_key_press(exp.keyboard.main_keyboard_index, [], {}, true);
                exp.keyboard.right_key = pressed_key(1);
                exp.keyboard.reponse_keys{2} = KbName(exp.keyboard.right_key);
                fprintf('key = ''%s''\n', exp.keyboard.reponse_keys{2});
            else
                exp.keypad = 1;
                exp.mouse = 0;
                exp.keyboard.keypad_index = input_device_by_prompt('Please press any key on the keypad\n', 'keyboard');
                fprintf('Press key for left response:... ');
                [was_pressed, press_time, pressed_key] = get_key_press(exp.keyboard.keypad_index, [], {}, true);
                exp.keyboard.left_key = pressed_key(1);
                exp.keyboard.reponse_keys{1} = KbName(exp.keyboard.left_key);
                fprintf('key = ''%s''\n', exp.keyboard.reponse_keys{1});
                
                fprintf('Press key for right response:... ');
                [was_pressed, press_time, pressed_key] = get_key_press(exp.keyboard.keypad_index, [], {}, true);
                exp.keyboard.right_key = pressed_key(1);
                exp.keyboard.reponse_keys{2} = KbName(exp.keyboard.right_key);
                fprintf('key = ''%s''\n', exp.keyboard.reponse_keys{2});
            end
        else
            exp.keyboard.left_key = 1;
            exp.keyboard.right_key = 2; %may need to change to 3 depending on mouse
            exp.mouse = 1;
            exp.keypad = 0;
           
       
        end
    end
end
