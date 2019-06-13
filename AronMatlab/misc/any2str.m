function [b] = any2str(a)
% Convert any variable to a string    

% Copyright 2008 Mike Claffey

% 11/22/08 misc improvements

    if ischar(a)
        b = a;
    elseif isempty(a)
        b = '';
    elseif iscell(a)
        if length(a) == 1
            b = any2str(a{1});
        else
            b = cellfun(@any2str, a, 'UniformOutput', false);
        end
    elseif isnumeric(a)
        b = num2str(a);
    elseif islogical(a);
        if a, b = 'true'; else b = 'false'; end;
    else
        switch class(a)
            case 'nominal'
                b = char(a);
            otherwise
                error('Unrecognized variable type')
        end
    end
end    
    