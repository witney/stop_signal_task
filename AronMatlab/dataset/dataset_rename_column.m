function [b] = dataset_rename_column(a, name_pairs)
% Rename the columns of a dataset
%
% a is the original dataset
% name_pairs is a M x 2 cell of old name / new names pairs
% b is the dataset with renamed fields

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)


% 05/01/08 original version

%% error checking
    if ~isa(a, 'dataset'), error('the first argument must be a dataset'); end;
    if size(name_pairs, 2) ~=2 || ~iscell(name_pairs), error('the second argument must be a Mx2 cell array'); end;
    
%%    
    col_names = get(a, 'VarNames');
    for i = 1:size(name_pairs, 1)
        old_name = name_pairs{i, 1};
        new_name = name_pairs{i, 2};
        col = find(strcmp(col_names, old_name));
        if isempty(col) || col==0, error('column %s was not found in the original dataset', old_name'); end;
        col_names{col} = new_name;
    end
    b = set(a, 'VarNames', col_names);
end