function dataset_to_csv(data, filename)
% Exports a dataset as a csv

% Copyright 2008 Mike Claffey (mclaffey[]ucsd.edu)


% 06/01/08 original version

    % default filename is none is provided
    if ~exist('filename', 'var')
        filename = sprintf('%s.csv', inputname(1));
    end
    
    % open file
    fid = fopen(filename, 'w');
    if fid < 0
        fprintf('Failed to open file: %s', filename);
        error('Could not write to file')
    end

    % export column names
    col_names = get(data, 'VarNames');
    col_count = length(col_names);
    for col = 1:col_count
        fprintf(fid, col_names{col});
        if col < col_count, fprintf(fid, ','); end;
    end
    fprintf(fid, '\n');

    % export data
    for row = 1:size(data, 1)
        for col = 1:col_count
            str = data{row, col_names{col}};
            if isa(str, 'nominal'), str = char(str); end;
            if isnumeric(str), str = num2str(str); end;
            fprintf(fid, str);
            if col < col_count, fprintf(fid, ','); end;
        end
        fprintf(fid, '\n');
    end

    fclose(fid);
    fprintf('Dataset %s exported to %s\n', inputname(1), filename);
end