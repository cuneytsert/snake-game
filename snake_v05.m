% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 5th version of our snake game. Please have a look at the    %
% previous versions before this one.                                      %
%                                                                         %
% In this version we create the snake using a for loop.                   %
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



% Define our snake's length as 5. It will cover 5 squares of our game board.
len = 5;

% **************
% CHANGES START
% **************

% Let's create our snake inside a for loop. The loop's counter "i" is used to
% change the x coordinate of each rectangle of the snake. The first one is
% at x=7, the 2nd one is at x=6, etc. The tail is at x=3. Our snake is horizontal,
% therefore, we are not changing the y coordinates of the rectangles.
for i = 1:len
   snake(i) = rectangle('Position', [8-i 10 1 1], 'FaceColor', 'black', 'EdgeColor', 'red');
end

% **************
% CHANGES END
% **************


% To randomize the food's location, we use MATLAB's built-in randi function.
foodX = randi([0 width-1]);    % A random integer number between 0 and width-1.
foodY = randi([0 height-1]);   % A random integer number between 0 and height-1.
food  = rectangle('Position', [foodX foodY 1 1], 'FaceColor', 'blue', 'EdgeColor', 'blue');


% TODO: Try to change the location and length of the snake.
