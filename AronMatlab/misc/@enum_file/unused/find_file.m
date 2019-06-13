function [file_name] = find_file(template, show_warnings)
% Uses dir() to look for existing files matching a template    

    if ~exist('show_warnings', 'var'), show_warnings = false; end;

    found_files = dir(template);
    if isempty(found_files)
        if show_warnings
            warning('enum_files:No_wildcard_match', 'Could not find file matching %s', template);
        end
        file_name = [];
    elseif length(found_files) > 1
        if show_warnings
            warning('enum_files:Wildcard_multiple_matches', 'Found more than one file matching %s', template);
        end
        file_name = [];
    else
        found_file_directory = fileparts(template);
        file_name = sprintf('%s/%s', found_file_directory, found_files(1).name);
    end    
end