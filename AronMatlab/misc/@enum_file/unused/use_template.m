function [file_name] = use_template(template, id, limit_to_existing)
% Fills a template in with id numbers
%
% [file_name] = use_template(template, id, limit_to_existing)

    if ~exist('limit_to_existing', 'var'), limit_to_existing = false; end;

    id_occurence_count = length(findstr(template, '%'));
    
    id_list = mat2cell_same_size(repmat(id, 1, id_occurence_count));
    
    file_name = sprintf(template, id_list{:});
    
%% if applicable, insert date/time stamp

    if limit_to_existing
        file_name = strrep(file_name, '#DATE#', '*');
        file_name = strrep(file_name, '#TIME#', '*');    
    else
        file_name = strrep(file_name, '#DATE#', datestr(now, 'mmm-dd-yyyy'));
        file_name = strrep(file_name, '#TIME#', strtrim(datestr(now, 'HH-MM-AM')));    
    end

    
%% If limiting to existing files or using a wildcard pattern, attempt to find file    
    if limit_to_existing || any(findstr(file_name, '*'))
        file_name = find_file(file_name, false);
    end
    
end