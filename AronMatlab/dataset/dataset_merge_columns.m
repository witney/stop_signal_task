function [merged_column] = dataset_merge_columns(a, merge_cols)
% Creates a column by merging values in each row across several columns
%
% [merged_column] = dataset_merge_columns(a, merge_cols)

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)


% 10/05/08 improved error handling
% 09/01/08 original version

%% error checking
    if ~isa(a, 'dataset')
        error('First argument must be a dataset')
    end
    if ~exist('merge_cols', 'var') || (ischar(merge_cols) && strcmp(merge_cols, ':')), merge_cols = get(a, 'VarNames'); end;
    if ischar(merge_cols), merge_cols = {merge_cols}; end;
    unknown_cols = setdiff(merge_cols, get(a, 'VarNames'));
    if ~isempty(unknown_cols)
        error('Unknown column: %s', unknown_cols{1})
    end

%% build a group labels column
    [rows, cols] = size(a);
    merged_column = cell(rows, 1);
    for i = 1:rows
        merge_value = '';
        for j = 1:length(merge_cols)
            merge_value = sprintf('%s_%s', merge_value, any2str(a{i, merge_cols{j}}));
        end
        merged_column{i} = merge_value(2:end); % remove last underscore
    end

end