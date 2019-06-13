function ef = rename_nickname(ef, nickname, new_name)
% Renames a file in the enum_files.file structure

    idx = get_nickname_idx(ef, nickname);
    
    if ~any(idx)
        error('Nickname %s could not be found', nickname')
    else
        ef.files(idx).nickname = new_name;
    end
    
end