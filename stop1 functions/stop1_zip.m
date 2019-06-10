function stop1_zip(base_dir, zip_mode)
    
    if ~exist('base_dir', 'var'), ef = stop1_files; base_dir = ef.base_dir; end;
    if ~exist('zip_mode', 'var')
        zip_mode = menu2('Create what type of zip?', {'All', 'No Data', 'Data Only', 'Cancel'});
        if all(~zip_mode) || strcmpi(zip_mode, 'cancel'), return; end;
    end;
    
%% generate directory list

    zip_items = dir(base_dir);
    zip_items = {zip_items.name};
    exclude_items = {'.', '..', '.DS_Store', 'zips'};
    zip_items = setdiff(zip_items, exclude_items);

    switch zip_mode
        case {[], '', 'all'}
            % do nothing
            zip_name = ['stop_v1_' datestr(now, 'yyyy_mm_dd') '.zip'];
            
        case 'no data'
            % option to exclude data directory
            zip_items = setdiff(zip_items, {'data'});
            zip_name = ['stop_v1_NO_DATA_' datestr(now, 'yyyy_mm_dd') '.zip'];
            
        case 'data only'
            zip_items = {'data'};
            zip_name = ['stop_v1_DATA_ONLY_' datestr(now, 'yyyy_mm_dd') '.zip'];
            
        otherwise
            error('Unknown zip mode: %s', zip_mode)
    end

%% create zip

    zip_location = [base_dir filesep 'zips' filesep zip_name];
    zip(zip_location, zip_items, base_dir)
    
%% report

    fprintf('Zip file created: %s\n', zip_name);
    fprintf('In directory: %s\n', fileparts(zip_location));
    
end
