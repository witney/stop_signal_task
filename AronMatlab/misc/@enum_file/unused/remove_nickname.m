function ef = remove_nickname(ef, nickname)
% Removes a nickname from the enum_files.file structure

    idx = get_nickname_idx(ef, nickname);
    
    ef.files(idx) = [];
    
end