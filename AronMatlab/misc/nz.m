function [b] = nz(a, null_value)
% Replaces empty and NaN values with a default value

% Copyright 2008 Mike Claffey mclaffey[]ucsd.edu

% 02/05/09 improved commenting and added handling of strings
% 09/17/08 Added isempty support

    if ~exist('null_value', 'var'), null_value = 0;end;
    
    % start off assuming a is not null and will be returned as is
    b = a;
    
    
    if isempty(a)
        % if a is any type of variable that can be evaulated with isempty() and it is empty, just return null_value
        b = null_value;
        
        
    % if a is not empty, nz() can look at certain varible types and determine if elements of it are empty (e.g. NaN)
        
    elseif isnumeric(a)
        % if a is a numeric matrix, fix the NaN values
        b(isnan(a))=null_value;

    elseif iscell(a)
        % if a is a cell, fix the NaN values
        b(cellfun(@isnan, a)) = {null_value};
        
    elseif isa(a, 'dataset')
        % if a is a dataset, process each column recursively
        for x = 1:size(a,2)
            a(:,x) = nz(a(:,x), null_value);
        end
        
    elseif ischar(a)
        % don't do anything special with elements of strings
        
    else
        error('nz can only accept matrices and cells')
    end
end