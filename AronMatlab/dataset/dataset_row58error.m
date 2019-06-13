function [error_exists] = dataset_row58error(dont_ask_to_fix)
% Checks for and offers to fix the row 58 for dataset assignments

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 02/23/09 original version


    error_exists = true;
    if ~exist('dont_ask_to_fix', 'var'), dont_ask_to_fix = false; end;
    
%% if matlab is new enough, don't even check

    if ~verLessThan('matlab', '7.8')
        fprintf('Your version of matlab is new enough to not require the fix\n')
        error_exists = false;
        return
    end

%% try producing the error  

    test_data = dataset({ones(60,2), 'value'});
    try
        test_data(58, :) = test_data(1, :);
        disp(test_data(2,:))
        error_exists = false;
    catch
        error_exists = true;
    end

%% no error, no problem    
    
    if ~error_exists
        fprintf('Your version of matlab did not produce any errors\n')
        return
    end

%% return without fixing, if requested

    if dont_ask_to_fix, return; end;
    
%% error found, offer to fix

    fprintf('Your version of matlab produces the dataset-row-58 error.\n')
    fprintf('This can be corrected by updating the /toolbox/stats/@dataset/subsasgn.m file.\n')
    fix_reply = input('If you would like to update the file, type "fix": ', 's');
    if ~strcmpi(fix_reply, 'fix')
        fprintf('Not updating matlab\n')
        return
    end

%% replace file to fix error

    source_file = which('row58error_fix_dataset_subsasgn.txt');
    dest_file = which('dataset/subsasgn.m');
    [status,message,messageid] = copyfile(source_file, dest_file);%,'f')
    if status == 1
        fprintf('File updated okay\n')
    else
        error('Unknown error when I tried to update the file: %s\n', message)
    end
    
%% try to clear classes

    fprintf('To complete the change, I need to execute "clear classes", which will erase any data in the workspace.\n')
    fprintf('If you do not want to do this know, you can type and execute "clear classes" at any point.\n')
    fix_reply = input('If you would like to do this now, type "clear": ', 's');
    if ~strcmpi(fix_reply, 'clear')
        fprintf('Not clearing classes, error will persist until you run "clear classes" or restart.\n')
        return
    end
    
    clear classes
    if ~dataset_row58error(true)
        fprintf('The problem has been fixed.\n')
    else
        fprintf('Could not fix the problem, unclear why.\n')
    end

end

