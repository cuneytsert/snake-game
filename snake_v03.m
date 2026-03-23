% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 3rd version of our snake game. Please have a look at the    %
% previous versions before this one.                                      %
%                                                                         %
% In this version we create a snake and a food using MATLAB's built-in    %
% rectangle function.                                                     %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Here is our figure window.
figure('Name', 'Snake Game', ...        % Give a name to the figure window.
       'MenuBar','none', ...            % Get rid of the menubar, we don't need it.
       'ToolBar','none', ...            % Get rid of the toolbar, we don't need it.
       'NumberTitle','off', ...         % Get rid of the number in the figure name .
       'Position', [200 200 650 600]);  % Set the size and position of the window.


% Let's play the game on a 20x20 board.
width = 20;      % Game board width
height = 20;     % Game board height


% And here is our axis.
ax = axes();               % We need an axes object to draw the snake and the food.
grid on;                   % Show grid lines.
axis equal;                % Set the aspect ratio of the x and y axes to 1.
ax.Box = 'on';             % Put a nice border around the game board to make it look nicer.
ax.XLim = [0 width];       % Set the horizontal axis limits.
ax.YLim = [0 height];      % Similar for the vertical axis.
ax.XTick = 0:1:width;      % Horizontal grid lines will be shown from 0 to width with increments of 1.
ax.YTick = 0:1:height;     % Similar for the vertical grid lines.



% **************
% CHANGES START
% **************

% Let's create our snake by placing a black rectangle inside our axes using
% MATLAB's built-in rectangle function. We position our rectangle such that
% its lower left corner is at x=3, y=10, and its length and height are 5 and 1,
% respectively. Our snake will cover 5 squares of our game board. It is a
% horizontally positioned snake.
snake = rectangle('Position', [3 10 5 1], 'FaceColor', 'black', 'EdgeColor', 'red');

% Let's also create a food by placing a blue rectangle. Its lower left corner
% is at x=10, y=15, and its size is 1x1, i.e. it will cover only 1 square of
% our game board. MATLAB has no separate function to create a square, therefore
% we are using the rectangle function again.
food  = rectangle('Position', [10 15 1 1], 'FaceColor', 'blue', 'EdgeColor', 'blue');


% TODO: Play with the location, size, color of the snake and the food.
