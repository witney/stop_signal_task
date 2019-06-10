function stop1_status
    
%% check for variables

    exp = [];
    trial_data = [];
    missing_variables = false;
    try
        exp = evalin('base', 'exp');
        trial_data = evalin('base', 'trial_data');
    catch
        missing_variables = true;
    end

    if isempty(exp),  fprintf('There is no exp variable loaded in the workspace\n'); end;
    if isempty(trial_data), fprintf('There is no trial_data variable loaded in the workspace\n'); end;
    if missing_variables, return; end;
    
%% basic reporting

    home
    fprintf('Subject: %d\n', exp.subject_id);
    fprintf('Current trial %d, block %d\n', exp.current_trial, trial_data.block(exp.current_trial));
    fprintf('Percent complete: %d%%\n', fix(nanmean(trial_data.complete)*100));
    fprintf('Started %d minutes ago (~%d minutes remaining)\n', ...
        round((GetSecs - trial_data.start_time(1)) / 60), ...
        round((size(trial_data,1) - exp.current_trial) * 3.05 / 60));
    fprintf('Number of successful stop trials: %d\n', sum(trial_data.trial_type=='stop' & nz(trial_data.correct, 0)));
    
    % go rt
    go_rt = nanmean(trial_data.rt(trial_data.trial_type=='go' & nz(trial_data.correct, 0)));
    fprintf('Go RT: %1.3f secs\n', go_rt);
    
    % stopping
    ssd = ssd_analyzer(trial_data.ssd, trial_data.correct, 'ssd_method', 'last half');
    fprintf('SSD:   %1.3f secs (last half method)\n', ssd);
    fprintf('SSRT:  %1.3f secs\n', go_rt - ssd);
    
%%


end
    
    
    
    