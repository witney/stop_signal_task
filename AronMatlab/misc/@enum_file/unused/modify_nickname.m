function ef = modify_nickname(ef, nickname, template)
% Adds or modifies a nickname in the enum_files.file structure

    idx = get_nickname_idx(ef, nickname);
    
    if any(idx)
        % modify existing nickname
        ef.files(idx).template = template;
    else
        % add a new nickname
        ef.files(end+1).nickname = nickname;
        ef.files(end).template = template;
    end
    
end