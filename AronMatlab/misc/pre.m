function [b] = pre(a)
% Displays a 10 line preview of a cell or dataset
    if isempty(a) || size(a,1)==0, fprintf('\n\tvariable is empty\n\n'); return; end;
    show_lines = min(10, size(a,1));
    b = a(1:show_lines,:);
end