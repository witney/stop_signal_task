%%modified by Nicki Swann 4/22/09 for standard stopping

function [exp] = stop1_initialize_sound(exp)

%STOP1_INITIALIZE_SOUND Load sound data (for Mac, prepare PsychPortAudio)
%     sound_file = [exp.files.base_dir '/config/ding.wav'];
%     [ding_wav, ding_freq, nbits] = wavread(sound_file);
%     exp.sound.stop_wav = ding_wav;
%     exp.sound.stop_freq = ding_freq;
     
     exp.sound.stop_freq = 6000;
     exp.sound.stop_wav = [MakeBeep(exp.sound.stop_freq, .10)', MakeBeep(exp.sound.stop_freq, .10)'];
     
    
%% PC Version

    
    if ispc
       % the PC version doesn't require any additional preparation
    
    
%% Mac Version - initialize psychportaudio    
    else
        InitializePsychSound;
        audio_port = PsychPortAudio('Open', [], [], 0, exp.sound.stop_freq, 2);
        exp.sound.audio_port = audio_port;
    end
    
%% test sound
    stop1_audio_prep_stop_signal(exp);
    stop1_audio_play_stop_signal(exp);

end
