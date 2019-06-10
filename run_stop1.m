cls

%% setup path

Screen('Preference', 'SkipSyncTests', 1); 
stop1_dir = nz(fileparts(mfilename('fullpath')), pwd);
addpath(stop1_dir);
addpath([stop1_dir filesep() '/bin']);
addpath([stop1_dir filesep() '/analysis']);
addpath([stop1_dir filesep() '/config']);
if ispc
    addpath([stop1_dir filesep() '/pc_hacks']);
end
ef = stop1_files;

%% create menu

dock_by_default(0);

menu_choices = { ...
    'Initialize'; ...
    'Change Settings'; ...
    'Practice'; ...
    'Run'; ...
    'Reset'; ...
    'Feedback'; ...
    'Load Subject'; ...
    'Analyze'; ...
    'Report'; ...
    'Save Subject'; ...
    'Admin'; ...
    'Cancel'; ...
    };

choice_num = menu('Which option?', menu_choices);

if choice_num == 0, choice = 'cancel'; else choice = lower(menu_choices{choice_num}); end;

switch choice
    case 'initialize'
        stop1_initialize
        
    case 'change settings'
        assert(logical(exist('exp', 'var')), 'There is no exp variable - try initializing or loading a subject');
        menu_choices = {'Inputs', 'Display', 'Sound', 'View SSDs', 'Change SSDs', 'Update File Locs'};
        menu_choice = menu('Change what setup?', menu_choices);
        if menu_choice == 0; return; else menu_choice = lower(menu_choices{menu_choice}); end;
        switch menu_choice
            case 'inputs'
                [exp] = stop1_initialize_inputs(exp);
            case 'display'
                [exp, w] = stop1_initialize_display(exp);
            case 'sound'
                [exp] = stop1_initialize_sound(exp);
            case 'view ssds'
                [exp] = stop1_ssds_display(exp);
            case 'change ssds'
                [exp] = stop1_ssds_change(exp);
            case 'change ssds'
                [exp] = stop1_ssds_change(exp);
            case 'update file locs'
                exp.files = ef;
        end
        
    case 'practice'
        menu_choices = {'10 Go trials', '20 with Stop trials'};
        menu_choice = menu('Run which practice?', menu_choices);
        if menu_choice == 0; return; end;
        switch menu_choice
            case 1
                exp = stop1_practice_a_going(exp);
            case 2
                exp = stop1_practice_b_stopping(exp);
           
        end
        
        
    case 'run'
        stop1_run
        
    case 'reset'
        [exp, trial_data] = stop1_reset(exp, trial_data);
        
    case 'feedback'
        block_num = input('Show feedback for what block? ');
        if isempty(block_num), return; end;
        [exp, trial_data] = stop1_block_feedback(exp, trial_data, [], block_num);
        cls
        
    case 'load subject'
        fprintf('Available subjects:\n\t%s\n', mat2str(ef.behav.ids'));
        subject_id = input('Load what id: ');
        if isempty(subject_id), return; end
        if ef.master(subject_id).exists
            response = input('Do you want to load the master file for this subject? (ENTER for yes, "n" for no) ', 's');
            if isempty(response)
                ef.master(subject_id).load;
            else                
                ef.behav(subject_id).load;
            end;
        else
            ef.behav(subject_id).load;
        end
        stop1_status
        fprintf('Click to <a href="matlab:[exp, trial_data] = stop1_analyze_subject(exp, trial_data);">analyze</a>\n');
        
    case 'analyze'
        [exp, trial_data] = stop1_analyze_subject(exp, trial_data, 'all');
        
    case 'report'
        menu_choices = {'Command', 'HTML'};
        menu_choice = menu('How do you want to display results?', menu_choices);
        if menu_choice == 0; return; else menu_choice = lower(menu_choices{menu_choice}); end;
        
        switch menu_choice
            case 'command'
                stop1_report
            case 'html'
                publish_clean('stop1_report.m', ef.html(exp.subject_id), 'html', true)
            case 'pdf'
                publish_clean('stop1_report.m', change_extension(ef.html(exp.subject_id), 'pdf'), 'pdf', true)

        end
        
    case 'save subject'
        assert(logical(exist('exp', 'var')), 'The exp variable does not exist');
        assert(logical(exist('trial_data', 'var')), 'The trial_data variable does not exist');
                    
        save(exp.files.master(exp.subject_id), 'exp', 'trial_data');
        fprintf('Master file for subject %d has been saved\n', exp.subject_id);
        
    case 'admin'
        
        response = menu2('Which function?', {'Create Zips', 'Create Help'});
        if ~response, return; end;
        
        switch response
            case 'create zips'
                stop1_zip(ef.base_dir);
                
            case 'create help'
                if ~exist('m2html', 'file'), fprintf('The <a href="http://www.artefact.tk/software/matlab/m2html/">m2html library</a> could not be found\n'); return; end;
                m2html('mfiles', ef.base_dir, 'htmldir','help', 'recursive','on','globalHypertextLinks','on')
        end

end

%% clear variables from global workspace

clear stop1_dir
clear choice choice_num
clear menu_choices menu_choice
clear ef