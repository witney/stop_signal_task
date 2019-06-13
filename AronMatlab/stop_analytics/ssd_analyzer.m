function [ssd, stats] = ssd_analyzer(ssds, success, varargin)
% Calculates ssrt based on ssd and stop success data
%
% [ssd, stats] = ssd_analyzer(SSD_ARRAY, SUCCESS_LOGICAL)
%
% [ssd, stats] = ssd_analyzer(... [, 'staircase', STAIRCASE_DATA])
% [ssd, stats] = ssd_analyzer(... [, 'ssrt_method', 'aron' / 'claffey' ])
% [ssd, stats] = ssd_analyzer(... [, 'show_graphs', BOOLEAN])
% [ssd, stats] = ssd_analyzer(... [, 'graph_name', GRAPH_NAME_STRING])

% 01/27/09 return raw stopping data
% 11/24/08 Added help text

%% process arguments
    p.staircase = [];
    p.show_graphs = false;
    p.ssrt_method = 'aron';
    p.chart_name = '';
    p = paired_params(varargin, p);
     
%%    
    
    ssd_count = length(ssds);    

    stats = struct();
    
    % aron method (average of last half)
    stats.aron_ssd = mean(ssds(round(ssd_count/2):end));
    if isempty(stats.aron_ssd), stats.aron_ssd =  NaN; end;

        
    % claffey method
    [ssd_group, ssd_accuracy] = grpstats(success, ssds, {'gname', 'mean'});
    ssd_group = cellfun(@str2double, ssd_group);    
    
    if all(isnan(success)) || all(isnan(ssds))
        stats.claffey_ssd = NaN;
    else
    

        % interpolate points
        ssd_i = [0:10:500];
        acc_i_linear = interp1(ssd_group, ssd_accuracy, ssd_i);
        acc_i_cubic = interp1(ssd_group, ssd_accuracy, ssd_i, 'spline');

        stats.claffey_ssd = ssd_i(find(acc_i_linear > .5, 1, 'last'));
        if isempty(stats.claffey_ssd), stats.claffey_ssd =  NaN; end;
    end
    
    % save stopping success as dataset
    stats.data = dataset({ssd_group, 'ssd'}, {ssd_accuracy, 'stop_success'});
    
%% plot
    if p.show_graphs
        if isempty(p.chart_name)
            chart_name = 'SSD By Trial';
        else
            chart_name = sprintf('%s: SSD By Trial', p.chart_name);
        end
        
        figure

        % ssd staircase
        ax(1) = subplot(2,1,1);
        hold on
        
        if isempty(p.staircase)
            % plot all SSDs as a single line        
            stairs(ssds)
        else
            % plot a separate line for each stair case
            stair_list = unique(p.staircase);
            for stair_num = 1:length(stair_list);
                stair_value = stair_list(stair_num);
                stair_idxs = find(p.staircase == stair_value);
                % plot
                stairs(stair_idxs, ssds(stair_idxs));
            end
        end
            
        max_ssd = round(max(ssds) * 1.1);
        plot_line(stats.aron_ssd, 'h', 'r');
        format_graph(ax(1), chart_name, 'Trial', [], [], [], 'SSD', [0 max_ssd], [0:.1:max_ssd], []);

        % ssd accuracy distribution
        ax(2) = subplot(2,1,2);
        hold on
        plot(ssd_group, ssd_accuracy, 'b')
        plot_line(stats.claffey_ssd, 'v', 'r');
        format_graph(ax(2), 'Stop success rate by SSD', 'SSD', [0 max_ssd], [], [], 'Stopping Success', [0 1.1], [0:.2:1], []);
    end
    
%% choose value to return
    switch p.ssrt_method
        case 'aron'
            ssd = stats.aron_ssd;
        case 'claffey'
            ssd = stats.claffey_ssd;
    end
    
end