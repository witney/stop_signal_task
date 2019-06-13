function ef = enum_file(varargin)
% Constructor for the enum_file class
%
%   ef = enum_file(TEMPLATE)
%
%   ef = enum_file(TEMPLATE, BASE_DIR)
%
% general properties:       ids, next id, template, search_ids
% file properties:          load, find, generate, exists




% Copyright Mike Claffey (mclaffey[]ucsd.edu)

    ef.base_dir = '';
    ef.template = '';
    ef.search_ids = 0:100 ;

    ef = class(ef, 'enum_file');
    
    switch nargin
        case 0
            return
        case 1
            ef.template = varargin{1};
        case 2
            ef.template = varargin{1};
            ef.base_dir = varargin{2};
        otherwise
            error('Incorrect number of input arguments')
    end
end