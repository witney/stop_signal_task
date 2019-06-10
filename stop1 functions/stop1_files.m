function [file_list] = stop1_files()
% Generate relevant file paths for this experiment
    
%% determine base directory
    base_dir = fileparts(mfilename('fullpath')); % get the directory for this file, probably in a /bin directory
    base_dir = fileparts(base_dir); % move up one more directory to the main experiment directory

%% create structure

    file_list.base_dir = base_dir;

    file_list.folder_s = enum_file('data/s%d/', base_dir);
    file_list.behav = enum_file('data/s%d/stop1_s%d_behav_#DATE#_#TIME#.mat', base_dir);
    file_list.html = enum_file('data/s%d/stop1_s%d_report.html', base_dir);
    file_list.master = enum_file('data/s%d/stop1_s%d_master.mat', base_dir);

end