function stop1_audio_prep_stop_signal(exp)
% If using PsychPortAudio, load the buffer    

    % don't do this for the pc
    if ispc, return; end;

    % stop any previous played sound (a kind of reset command)
    PsychPortAudio('Stop', exp.sound.audio_port);
    
    % fill buffer (now just waiting on a start command)
    PsychPortAudio('FillBuffer', exp.sound.audio_port, exp.sound.stop_wav');
    
end