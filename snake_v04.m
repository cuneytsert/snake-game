% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 4th version of our snake game. Please have a look at the    %
% previous versions before this one.                                      %
%                                                                         %
% In this version we change the way the snake is created. Now it is       %
% composed of multiple squares instead of a single rectangle. We also     %
% randomized the position of the food.                                    %
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

% Define our snake's length as 5. It will cover 5 squares of our game board.
len = 5;

% Instead of creating our snake as one rectangle of size 5x1, let's create
% it as 5 rectangles of size 1x1 each, i.e. 5 squares actually. Therefore,
% our snake will be an array of rectangles. This is necessary for our game
% because our snake will make turns in the future and it won't stay as a
% single rectangle. It will take weird shapes. Using an array of rectangles
% instead of a single rectangle will allow our snake to take any shape.

% Our snake's head is at x=7, y=10. And its tail is at x=3, y=10. It is a
% horizontally positioned snake.
snake(1) = rectangle('Position', [7 10 1 1], 'FaceColor', 'black', 'EdgeColor', 'red');
snake(2) = rectangle('Position', [6 10 1 1], 'FaceColor', 'black', 'EdgeColor', 'red');
snake(3) = rectangle('Position', [5 10 1 1], 'FaceColor', 'black', 'EdgeColor', 'red');
snake(4) = rectangle('Position', [4 10 1 1], 'FaceColor', 'black', 'EdgeColor', 'red');
snake(5) = rectangle('Position', [3 10 1 1], 'FaceColor', 'black', 'EdgeColor', 'red');


% To randomize the food's location, we will use MATLAB's built-in randi
% function. Note that the lower left corner of the square at the lower left
% corner of the board is (0,0), and the lower left corner of the square at
% the top right corner of the board is (width-1,height-1). We need to
% understand these limits in order to place the food inside the board.
foodX = randi([0 width-1]);    % A random integer number between 0 and width-1.
foodY = randi([0 height-1]);   % A random integer number between 0 and height-1.
food  = rectangle('Position', [foodX foodY 1 1], 'FaceColor', 'blue', 'EdgeColor', 'blue');


% TODO: Run thecode multiple times to see how the food is placed randomly.
%       Try to change the location and length of the snake.
