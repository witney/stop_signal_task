function [varargout] = scr(open_mini_window)
% Opens a PsychToolBox screen and saves ID to variable 'w'
%
% [w] = scr(OPEN_MINI_WINDOW)
%
% [w, screen_parameters] = scr(OPEN_MINI_WINDOW)
%
% If OPEN_MINI_WINDOW is not provided or is zero, scr() opens a full screen
%
% To open a mini window that does not cover the full screen (useful in
% debugging), set OPEN_MINI_WINDOW = 1 through 4. The window will open in a
% quarter of the screen, with 1 being the top-left, 2 being top-right, 3
% bottom-right, 4 bottom-left
%
% If the function is saved to an output argument, the screen pointer is
% returned
%
% If no output argument is provided, the screen pointer to the variable w
% in the base workspace 
%

% Copyright 2008-2009 Mike Claffey mclaffey[]ucsd.edu

% 02/05/09 added feature for gathering screen parameters
% 09/18/08 upgrade to function and pip option
    

    if ~exist('open_mini_window', 'var')
        open_mini_window = 0;
    elseif ~isnumeric(open_mini_window) || open_mini_window < 0 || open_mini_window > 4
        error('open_mini_window must be a scalar between 0 and 4')
    end 

    if IsOSX
        % This command doesn't work for PCs
        Screen('Preference','VisualDebugLevel',0);
    end
    screen_id = max(Screen('Screens'));
    
    if ~open_mini_window
        w = Screen(screen_id, 'OpenWindow');
    else
        screen_pos = get(0, 'MonitorPositions');
        switch open_mini_window
            case 1
                mini_coords = coords_from_margins([.02 .02 .5 .5], screen_pos);
            case 2
                mini_coords = coords_from_margins([.5 .02 .02 .5], screen_pos);
            case 3
                mini_coords = coords_from_margins([.5 .5 .02 .02], screen_pos);
            case 4
                mini_coords = coords_from_margins([.02 .5 .5 .02], screen_pos);
        end
        w = Screen(screen_id, 'OpenWindow', 255, mini_coords);
    end

%% set text defaults

        Screen('TextSize', w, 36);
        Screen('TextFont', w, 'Arial');
        Screen('TextColor', w, 255); %white
        
%% output arguments    
    
    if nargout == 0
        % if not output variables were requested, assign w to global workspace
        
        assignin('base', 'w', w);
    elseif nargout == 1
        varargout = {w};

%% Gather useful screen parameters

    elseif nargout == 2
    
        sp = struct(); % wp stands for screen parameters
        
        [sp.width, sp.height] = Screen(w, 'WindowSize');
        sp.x_center=sp.width/2;
        sp.y_center=sp.height/2;

        if IsOSX
            sp.colors.black=BlackIndex(w); % Should equal 0.
            sp.colors.white=WhiteIndex(w); % Should equal 255.
        else
            sp.colors.black=0; % Should equal 0.
            sp.colors.white=255; % Should equal 255.
        end
        
        sp.colors.red = [255 0 0];
        sp.colors.green = [0 255 0];
        sp.colors.blue = [0 0 255];

        varargout = {w, sp};

%%
        
        
    else
        error('More than two output variables were requested')
    end
    
end
