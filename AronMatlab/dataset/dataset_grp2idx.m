function [group_ids, group_names, group_column] = dataset_grp2idx(a, group_cols)
% Creates an index column from grouping columns
%
% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)


% 10/05/08 improved error handling
% 09/01/08 original version

%% error checking
    if ~isa(a, 'dataset')
        error('First argument must be a dataset')
    end
    if ~exist('group_cols', 'var'), group_cols = get(a, 'VarNames'); end;
    if ischar(group_cols), group_cols = {group_cols}; end;
    unknown_cols = setdiff(group_cols, get(a, 'VarNames'));
    if ~isempty(unknown_cols)
        error('Unknown grouping column: %s', unknown_cols{1})
    end

%% build a group labels column
    [rows, cols] = size(a);
    group_names = cell(rows, 1);
    for i = 1:rows
        group_label = '';
        for j = 1:length(group_cols)
            group_value = any2str(a{i, group_cols{j}});
            group_label = [group_label group_value '_']; %#ok<AGROW>
        end
        group_label(end) = []; % remove last underscore
        group_names{i} = group_label;
    end
    
%% determine grouping
    [group_ids, group_names] = grp2idx(group_names);
    group_column = group_names(group_ids);

end