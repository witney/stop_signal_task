function [stats] = dataset_grpmean(data, grp_fields, data_fields)
% An easy-to-use shortcut for calculating column means based on dataset/grpstats()
%
% [STATS] = dataset_grpmean(DATA [, GROUP_FIELDS] [, DATA_FIELDS])
%
% dataset_grpmean() provides several shortcuts for deriving means on datasets. First, it
%   automatically uses nanmean() as the aggregating function. Second, if GROUP_FIELDS or DATA_FIELDS
%   are not specified, it finds them automatically baed on column type. Third, it avoids renaming
%   columns (e.g. the 'nanmean_' prefix) that grpstats does by default.
%
% Example:
%
%   trial_data = 
%         cue      trial_type    cue_rt     valid
%         xxx      go                NaN    1    
%         right    stop              NaN    1    
%         right    stop              NaN    1    
%         left     go            0.77349    1    
%         xxx      go            0.64433    1    
%         xxx      stop              NaN    1    
%
%   dataset_grpmean(trial_data) % find group and data columns automatically
%   ans = 
%                       cue      trial_type    count    cue_rt     valid
%         xxx_go        xxx      go            2        0.64433    1    
%         xxx_stop      xxx      stop          1            NaN    1    
%         left_go       left     go            1        0.77349    1    
%         right_stop    right    stop          2            NaN    1    
%
%   dataset_grpmean(trial_data, 'cue') % specify cue column as only group field (collapse across 'trial_type')
%   ans = 
%                  cue      count    cue_rt     valid
%         xxx      xxx      3        0.64433    1    
%         left     left     1        0.77349    1    
%         right    right    2            NaN    1    
%
%   dataset_grpmean(trial_data, [], 'cue_rt') % don't specify group columns, only average 'cue_rt' column
%   ans = 
%                       cue      trial_type    count    cue_rt 
%         xxx_go        xxx      go            2        0.64433
%         xxx_stop      xxx      stop          1            NaN
%         left_go       left     go            1        0.77349
%         right_stop    right    stop          2            NaN
%
%   dataset_grpmean(trial_data, 'cue', 'cue_rt') % specify group and data columns
%   ans = 
%                  cue      count    cue_rt 
%         xxx      xxx      3        0.64433
%         left     left     1        0.77349
%         right    right    2            NaN
%
% See also: grpstats, dataset/grpstats, nanmean

% Copyright 2009 Mike Claffey (mclaffey[]ucsd.edu)
%
% 02/12/09 original version

  
%% argument checking

    if ~exist('grp_fields', 'var') || isempty(grp_fields), grp_fields = {}; end;
    if ischar(grp_fields), grp_fields = {grp_fields}; end;
    if ~exist('data_fields', 'var') || isempty(data_fields), data_fields = {}; end;
    if ischar(data_fields), data_fields = {data_fields}; end;
    column_names = get(data, 'VarNames');
    assert(isa(data, 'dataset'), 'First argument must be a dataset');
    assert(iscell(grp_fields), 'Second argument must be a string or cell array of strings');
    assert(isempty(setdiff(grp_fields, column_names)), 'Some of the GROUP_FIELDS are not valid column names');
    assert(iscell(data_fields), 'Third argument must be a string or cell array of strings');
    assert(isempty(setdiff(data_fields, column_names)), 'Some of the DATA_FIELDS are not valid column names');        
    
%% if either group_fields or data_fields aren't specified, gather classes of columns
    if isempty(grp_fields) || isempty(data_fields)
        column_field_types = cell(size(data,2),1);
        for x = 1:size(data,2)
            column_field_types{x, 1} = class(data{1, x});
        end
        
        % if group fields are not specified, find text-type columns
        if isempty(grp_fields)
            grp_field_index = strcmp('char', column_field_types) | strcmp('ordinal', column_field_types) | strcmp('nominal', column_field_types);
            grp_fields = column_names(grp_field_index);
        end
        
        % if data fields are not specified, find numeric (averageable) columns
        if isempty(data_fields)
            data_fields_index = strcmp('double', column_field_types) | strcmp('logical', column_field_types) | strncmp('uint', column_field_types, 4);
            data_fields = column_names(data_fields_index);
        end

    end
    
%%    
    stats = grpstats(data, grp_fields, {'nanmean'}, 'DataVars', data_fields, 'VarNames', {grp_fields{:}, 'count', data_fields{:}});        
    
end