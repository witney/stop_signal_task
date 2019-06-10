%
%   stop1_run                    - The main script that iterates through trial_data

% Setup scripts
%   stop1_initialize             - Run all necessary setup, including data generation and hardware prepartiong
%   stop1_initialize_display     - Test the screen and save the basic parameters returned by scr()    
%   stop1_initialize_inputs      - Finds input devices and confirms keys being used
%   stop1_initialize_sound       - Load sound data (for Mac, prepare PsychPortAudio)

%   stop1_data_generate          - Generate trial_data for experiment
%   stop1_data_format            - Add all necessary columns, change column format and order

%   stop1_block_start            - Run at the beginning of each block (currently just a placeholder)
%   stop1_block_interim_rest     - Provide a rest to subject (press spacebar to continue)
%   stop1_block_end              - Display feedback graphs for block

%   stop1_trial                  - Runs all necessary actions for a single trial (also used for practice trials)
%   stop1_trial_get_response     - Display prompts & stimuli, and get key responses    
%   stop1_trial_check_response   - Check outcome of subject response and adjust SSD (if applicable)
%   stop1_trial_feedback         - Display feedback in command window or screen after each trial (used for practice)

%   stop1_practice_a_20go        - 
%   stop1_practice_b_20ms        - 
%   stop1_practice_c_40msns      - 

%   scramble_groups_of_trials    - [trial_order] = scramble_groups_of_trials(trial_count, group_size)    
%   stop1_draw_background        - Draw black background
%   stop1_audio_play_stop_signal - Play the stop signal    
%   stop1_audio_prep_stop_signal - If using PsychPortAudio, load the buffer    
%   stop1_files                  - Generate relevant file paths for this experiment
%   stop1_reset                  - Change current trial    

