% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 8th version of our snake game. Please have a look at the    %
% previous versions before this one.                                      %
%                                                                         %
% In this version we detect when the snake hits the right wall, and end   %
% the game when this happens. We also display "Welcome" and "Game over"   %
% messages in the command window.                                         %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% **************
% CHANGES START
% **************
clc    % Clear the command window

disp("Welcome to the snake game.")

% **************
% CHANGES END
% **************


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


% Define the snake's initial coordinates as a len by 2 matrix.
snakeCoord = [7 10;   
              6 10;
              5 10;
              4 10;
              3 10];

% Use these coordinates to create our snake's squares
for i = 1:len
   snake(i) = rectangle('Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1], ...
                        'FaceColor', 'black', ...
                        'EdgeColor', 'red');
end


% To randomize the food's location, we use MATLAB's built-in randi function.
foodX = randi([0 width-1]);    % A random integer number between 0 and width-1.
foodY = randi([0 height-1]);   % A random integer number between 0 and height-1.
food  = rectangle('Position', [foodX foodY 1 1], 'FaceColor', 'blue', 'EdgeColor', 'blue');


pause(2);  % Pause 2 seconds before entering the game loop.


% This is the main game loop, where the snake moves towards right.
while(1)
   % Calculate the new positions of the snake's coordinates.
   for i = 1:len
      snakeCoord(i,1) = snakeCoord(i,1) + 1;   % Increase x coordinates by 1 to
                                               % move the snake towards right.
                                               % Do not change the y coordinates.
   end

   % **************
   % CHANGES START
   % **************

   % Detect if the snake hits the right wall to end the game.
   % Check if the new x position of snake's head went beyond the right wall or not.
   if snakeCoord(1,1) > width-1
      disp("Game Over.")    % Display this message in the command window
      break                 % Go out of the game loop, i.e. terminate the code.         
   end

   % Move the snake on the screen if the game did not end
   for i = 1:len
      set(snake(i), 'Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1]);
   end

   % **************
   % CHANGES END
   % **************

   pause(0.3);   % Pause a bit to make snake's motion visible.
end


% TODO: Try to make it stop when it hits any wall. 
