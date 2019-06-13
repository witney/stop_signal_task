function [KeyIsDown, press_time, keyCode] = KbCheck_many_keyboards(keyboard_pointers)

    if isempty(keyboard_pointers) || all(keyboard_pointers == 0)
        [KeyIsDown, press_time, keyCode] = KbCheck();
    elseif length(keyboard_pointers) == 1
        [KeyIsDown, press_time, keyCode] = KbCheck(keyboard_pointers);
    else
        KeyIsDown = []; press_time=[]; keyCode=[];
        for x = 1:length(keyboard_pointers)
            [KeyIsDown(x), press_time(x), keyCode(x,:)] = KbCheck(keyboard_pointers(x)); %#ok<AGROW>
        end
        KeyIsDown = any(KeyIsDown);
        press_time = min(press_time);
        keyCode = max(keyCode, 1);
    end

end