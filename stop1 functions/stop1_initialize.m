%STOP1_INITIALIZE Run all necessary setup, including data generation and hardware prepartiong
%%
home;
exp = struct();
%Screen('Preference', 'SkipSyncTests', 1); 
%% setup paths of typically used files
exp.files = stop1_files;    

%% debug mode
exp.debug = logical(~isempty(input('Use standard mode? (Type ''d'' for debug mode, press ENTER for standard): ', 's')));

%% subject information
if exp.debug
    exp.subject_id = 0;
    
else
    next_subject_id = exp.files.behav.next_id;
    exp.subject_id = input(sprintf('What subject number? (Next unused ID is %d - Press ENTER to use): ', next_subject_id));
    if isempty(exp.subject_id), exp.subject_id = next_subject_id; end;
    exp.irb = get_irb_info;
end
exp.behav_file = exp.files.behav(exp.subject_id);

%% choose language
[exp] = stop1_initialize_language(exp);
%[exp] = stop1_initialize_daq(exp);



%% check for keypads
[exp] = stop1_initialize_inputs(exp);

%% setup screen and calculate graphic locations
[exp, w] = stop1_initialize_display(exp);

%% setup sound
[exp] = stop1_initialize_sound(exp);

%% initialize ssds
[exp] = stop1_ssds_initialize(exp);
%% generate trial data
fprintf('Generating trial data...')
[exp, trial_data] = stop1_data_generate(exp);
fprintf('Done\n\n')

%% make sure file can be saved
fprintf('Making subject directory: %s\n', fileparts(exp.behav_file));
mkdir(fileparts(fileparts(exp.behav_file))); % make data directory
mkdir(fileparts(exp.behav_file)); % make subject directory
save(exp.behav_file, 'exp', 'trial_data');

%% report completion
fprintf('Initialization complete\n');

