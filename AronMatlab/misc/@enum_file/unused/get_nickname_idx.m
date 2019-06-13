function [idx] = get_nickname_idx(ef, nickname)
% Returns the index of a nickname in the enum_files.files structure

    idx = strcmpi(nickname, {ef.files.nickname});
    if ~any(idx), idx = []; end;

end