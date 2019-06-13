function publish_clean(script_name, file_name, file_format, open_in_system)
    
    
%% Error checking

    if ~exist('script_name', 'var')
        error('Must provide a script name to publish')
    else
        [script_dir, script_file_name] = fileparts(which(script_name));
        if isempty(script_file_name)
            error('Could not find script: %s to publish', script_name);
        else
            script_name = which(script_name);
        end
    end

    if ~exist('file_name', 'var') || isempty(file_name)
        file_name = fullfile(script_dir, script_file_name);
    end
    if ~exist('file_format', 'var')
        file_format = 'html';
    else
        file_format = lower(file_format);
    end;
    if ~ismember(file_format, {'html', 'latex', 'pdf'}); error('Unrecognized format: %s', file_format); end;

    if ~exist('open_in_system', 'var'), open_in_system = true; end;
    
%% specific publishing options
    if strcmpi(file_format, 'pdf')
        pub_options.format = 'latex';
    else
        pub_options.format = file_format;
    end
    pub_options.outputDir = fileparts(file_name);
    if isempty(pub_options.outputDir), pub_options.outputDir = pwd; end;
    %pub_options.imageFormat = '';
    pub_options.maxHeight = [];
    pub_options.maxWidth = [];
    pub_options.showCode = false;
    pub_options.useNewFigure = false;
    
%% publish
    publish(script_name, pub_options);

%% File handling    
    
    % get rid of extension
    script_name = change_extension(script_name, '');

    % file handling
    switch file_format
        case 'html'
            % rename file
            movefile(sprintf('%s/%s.html', pub_options.outputDir, script_file_name), file_name);
        case 'latex'
            movefile(sprintf('%s/%s.tex', pub_options.outputDir, file_script_name), file_name);
        case 'pdf'
            file_name = tex_to_pdf(sprintf('%s/%s.tex', pub_options.outputDir, script_file_name), file_name);
            delete(sprintf('%s/%s.tex', pub_options.outputDir, script_name));
    end
    
    % open file, if requested
    if open_in_system
        system(sprintf('open %s', file_name))
    end    
    
end