function stop1_audio_play_stop_signal(exp)
% Play the stop signal    

%% pc version

    % This takes approximately 7 ms to play, see comment below
    if ispc
        sound(exp.sound.stop_wav, exp.sound.stop_freq);
        return
    end


%% mac version

    % This takes approximately 25 ms to play the sound, which introduces a slim possibility of
    % missing a button push during this time back in the trial loop
    
    try
        PsychPortAudio('Start', exp.sound.audio_port, 1, 0, 1);
    catch
        beep
        warning('PsychPortAudio failed to play the stop signal')
        stop1_audio_prep_stop_signal(exp)
    end
    
end
    