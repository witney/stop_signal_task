function stop1_action_send_TTL_pulse(exp)
   
    if ispc
        if exist('lptwrite', 'file')       
            lptwrite(hex2dec('410'),1);
            WaitSecs(0.025);
            lptwrite(hex2dec('410'),0);
        else
            warning('Could not find lptwrite file, not sending TTL pulse')
        end
        
    end
    
end