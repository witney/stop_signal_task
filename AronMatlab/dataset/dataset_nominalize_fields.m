function [data] = dataset_nominalize_fields(data, field_list)
% Convert mulitple fields in a dataset to nominal type
%
% [DATA] = dataset_nominalize_fields(DATA, FIELD_LIST)
    
% Copyright Mike Claffey 2009 (mclaffey[]ucsd.edu)
%
% 02/09/09 original version

%% check arguments
    assert(isa(data, 'dataset'), 'First argument must be a dataset.')
    if ischar(field_list), field_list = {field_list}; end;
    assert(iscell(field_list), 'FIELD_LIST must be either a string or cell array of strings')
    
%% iterate through each field in field_list and try converting to a nominal

    failed_convert_fields = {};
    
    for x = 1:length(field_list)
        try
            data.(field_list{x}) = nominal(data.(field_list{x}));
        catch
            failed_convert_fields{end+1} = field_list{x}; %#ok<AGROW>
        end
    end
        
%% report any errors
    
    if ~isempty(failed_convert_fields)
        warning('dataset_nominalize_fields:failed_fields', 'The following fields could not be converted:')
        disp(failed_convert_fields);
    end
    
end