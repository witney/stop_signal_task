function [data2] = dataset_rows2cols(data1, row_fields, index_fields, data_fields)

%% set up variables  
    if ~iscell(row_fields), row_fields = {row_fields}; end;
    if size(row_fields, 2) > 1, row_fields = row_fields'; end;
    if ~iscell(index_fields), index_fields = {index_fields}; end;
    if size(index_fields, 2) > 1, index_fields = index_fields'; end;
    index_fields = flipud(index_fields);
    if ~iscell(data_fields), data_fields = {data_fields}; end;
    if size(data_fields, 2) > 1, data_fields = data_fields'; end;
    data_fields = flipud(data_fields);
    
    index_field = index_fields{1};
    unused_index_fields = flipud(index_fields(2:end));
    index_fields_values = unique(data1.(index_field));
    join_key_fields = vertcat(row_fields, unused_index_fields);
        
    switch class(index_fields_values)
        case 'nominal'
            index_fields_values = getlabels(index_fields_values)';
    end
    
%% iterate through each value of the first index_field    
    
    for x = 1:length(index_fields_values)
        index_fields_value = index_fields_values{x};
        data_temp = data1(data1.(index_field)==index_fields_value, vertcat(row_fields, data_fields, unused_index_fields));
        data_temp.key = dataset_merge_columns(data_temp, join_key_fields);
        old_warnings = warning('off', 'stats:dataset:setvarnames:ModifiedVarnames');
        data_temp = dataset_append_varnames(data_temp, [index_fields_value '_'], '', data_fields);
        warning(old_warnings);
        
        if x == 1
            data2 = data_temp;
        else
            data_temp(:, {row_fields{:}, unused_index_fields{:}}) = [];
            data2 = join(data2, data_temp);
        end
    end

    data2 = set(data2, 'ObsName', data2.key);
    data2.key = [];
    
%% recursive processing of additional index_fields

    if ~isempty(unused_index_fields)
        new_data_fields = setdiff(get(data2, 'VarNames'), vertcat(row_fields, unused_index_fields));
        data2 = dataset_rows2cols(data2, row_fields, unused_index_fields, new_data_fields);
        
        % fix column order
        data_col_count = size(data2,2) - length(row_fields);
        data_field_count = length(data_fields);
        data_set_count = data_col_count / data_field_count;
        col_order = repmat([1:data_set_count]' * length(data_fields), 1, data_field_count) + repmat([1:data_field_count], data_set_count, 1)  + length(row_fields) - 2;
        data2 = data2(:, [1:length(row_fields) col_order(:)']);
    end    
    
end