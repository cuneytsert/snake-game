% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 2nd version of our snake game. Please have a look at the    %
% 1st version before this one.                                            %
%                                                                         %
% In this version we add an "axes" to the figure window so that we can    %
% draw things inside it.                                                  %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Our game board is a standard MATLAB figure window.

figure('Name', 'Snake Game', ...        % Give a name to the figure window.
       'MenuBar','none', ...            % Get rid of the menubar, we don't need it.
       'ToolBar','none', ...            % Get rid of the toolbar, we don't need it.
       'NumberTitle','off', ...         % Get rid of the number in the figure name .
       'Position', [200 200 650 600]);  % Set the size and position of the window.


% **************
% CHANGES START
% **************

% Let's play the game on a 20x20 board.
width = 20;      % Game board width
height = 20;     % Game board height

ax = axes();               % We need an axes object to draw the snake and the food.
                           % We use MATLAB's built-in axes function for this. We give our
                           % axes the name ax, so that we can use it later.
grid on;                   % Show grid lines.
axis equal;                % Set the aspect ratio of the x and y axes equal to 1 so that
                           % if the user resizes the figure window, everything will look
                           % nicely scaled.
ax.Box = 'on';             % Put a nice border around the game board to make it look nicer.
                           % Aesthetics is important :-)

ax.XLim = [0 width];       % Set the horizontal axis limits.
ax.YLim = [0 height];      % Similar for the vertical axis.

ax.XTick = 0:1:width;      % Horizontal grid lines will be shown from 0 to width with increments of 1.
                           % This will let us see all the squares of the game board.
ax.YTick = 0:1:height;     % Similar for the vertical grid lines.


% Now we have a nice 20x20 board game, divided into 400 small squares. Our
% snake will move on these squares.


% TODO: Remove some of the above axes settings to see their effects. 
