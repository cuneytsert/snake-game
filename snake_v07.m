% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 7th version of our snake game. Please have a look at the    %
% previous versions before this one.                                      %
%                                                                         %
% In this version we create a new variable to store the coordinates of    %
% rectangles that make up our snake. And then use it to move the snake.   %
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

% In our game we will be accessing and modifying the coordinates of the rectangles
% that make up our snake a lot. Let's store these in a matrix of size len by 2.
% For len=5, it will be a 5x2 matrix. Each row will correspond to one square of
% the snake. First column will store the x coordinates, and the 2nd column will
% store the y coordinates.
snakeCoord = [7 10;   
              6 10;
              5 10;
              4 10;
              3 10];

% Let's now use these coordinates to create the squares that form our snake.
for i = 1:len
   snake(i) = rectangle('Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1], ...
                        'FaceColor', 'black', ...
                        'EdgeColor', 'red');
end

% **************
% CHANGES END
% **************



% To randomize the food's location, we use MATLAB's built-in randi function.
foodX = randi([0 width-1]);    % A random integer number between 0 and width-1.
foodY = randi([0 height-1]);   % A random integer number between 0 and height-1.
food  = rectangle('Position', [foodX foodY 1 1], ...
                  'FaceColor', 'blue', ...
                  'EdgeColor', 'blue');

pause(2);  % Pause 2 seconds before entering the game loop.


% **************
% CHANGES START
% **************

% Let's use our new snakeCoord variable to move the snake towards right.
% This is easier than before.
while(1)   % Game loop
   for i = 1:len
      snakeCoord(i,1) = snakeCoord(i,1) + 1;   % Increase x coordinates by 1 to
                                               % move the snake towards right.
                                               % Do not change the y coordinates.
     
      % Update Position(1), i.e the x coordinate, of snake's i-th square.
      set(snake(i), 'Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1]);
   end

   pause(0.3);   % Pause a bit to see the motion of the snake.
   
end


% TODO: Try to change the motion of the snake towards left, up or down.
%       Try to make it stop when it hits a wall. 