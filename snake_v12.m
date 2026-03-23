% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 12th version of our snake game. Please have a look at the   %
% previous versions before this one.                                      %
%                                                                         %
% This is a version with some major changes. We begin controlling the     %
% snake's motion using the arrow keys. For this, a new variable called    %
% direction is introduced to detect where our snake is moving towards.    %
% It can be 1, 2, 3 or 4, meaning right, up, left and down. Also we       %
% changed the moveSnake function because now snakeis motion is not simply %
% towards right. Finally, we now end the game when the snake hits any of  %
% the walls, not ony the right wall. Our snake can turn, and our game     %
% starts to look like the original one.                                   %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v12()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is our main function. It is the first function is our code. Its name
% is the same as the name of the file to avoid confusions.

global ax width height isGameOver isPaused


% Here is our figure window.
figure('Name', 'Snake Game', ...           % Give a name to the figure window.
       'MenuBar','none', ...               % Get rid of the menubar, we don't need it.
       'ToolBar','none', ...               % Get rid of the toolbar, we don't need it.
       'NumberTitle','off', ...            % Get rid of the number in the figure name .
       'Position', [200 200 650 600], ...  % Set the size and position of the window.
       'KeyPressFcn', @keyPressed);        % Bind the key press event to our new keyPressed function.


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


startGame();   % Call the startGame function


% This is the main game loop, where the snake moves.
while(1)
   if ~isPaused   % Move the snake only if the game is NOT paused
      moveSnake();   % Call the moveSnake function
   end

   % Terminate the game loop if the game ended
   if isGameOver
      % Show the "Game Over" text close to the top of the axes.
      gameOverText = text(width/2, height-1, 'Game Over', 'FontSize', 15, ...
                          'HorizontalAlignment', 'center', 'Color', 'red');
      disp("Game Over.")
      break    % Terminate the game loop
   end

   pause(0.4);   % Pause a bit to make snake's motion visible
end

end  % of the main function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver isPaused direction

clc    % Clear the command window

disp("Welcome to the snake game.")
disp("Pause/continue with the spacebar.")
disp("Use arrow keys to turn the snake.")
disp("It cannot eat the foods yet.")


% Initialize the flags and motion direction
isGameOver = 0;   % Game is not over initially
isPaused = 0;     % Game is not paused initially
direction = 1;    % Snake moves towards right initially 

% Define our snake's length as 5. It will cover 5 squares of our game board.
len = 5;


% Define the snake's initial coordinates as a len by 2 matrix.
snakeCoord = [5 10;   
              4 10;
              3 10;
              2 10;
              1 10];

% Use these coordinates to create our snake's squares
for i = 1:len
   snake(i) = rectangle('Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1], ...
                        'FaceColor', 'black', ...
                        'EdgeColor', 'red');
end


% To randomize the food's location, we use MATLAB's built-in randi function.
foodX = randi([0 width-1]);    % A random integer number between 0 and width-1.
foodY = randi([0 height-1]);   % A random integer number between 0 and height-1.
food  = rectangle('Position', [foodX foodY 1 1], ...
                  'FaceColor', 'blue', ...
                  'EdgeColor', 'blue');

pause(2);   % Pause 2 seconds at the beginning of the game.

end  % of the function startGame




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver direction

% **************
% CHANGES START
% **************

% Update the snake's position by moving it forward. But in this version the
% snake can make turns. Therefore, it is not a single long rectangle anymore.
% The head of the snake moves according to the current motion direction. It
% can be any direction depending on how the user presses the arrow keys.
% The motion of the remaining squares (other than the head square) is simple,
% because they just move to the position of the square in front of them.

% First determine the new position of snake's head by looking at the motion
% direction. Below we use MATLAB's switch statement, which is similar to the
% if statement in functionality.
switch direction
   case 1  % Going right
      % Move the head square towards right. Increase its x coord. by 1, do not change its y coord.
      newHeadX = snakeCoord(1,1) + 1;
      newHeadY = snakeCoord(1,2);
   case 2  % Going up
      % Move the head square upwards. Increase its y coord. by 1, do not change its x coord.
      newHeadX = snakeCoord(1,1);
      newHeadY = snakeCoord(1,2) + 1;
   case 3  % Going left
      % Move the head square towards left. Decrease its x coord. by 1, do not change its y coord.
      newHeadX = snakeCoord(1,1) - 1;
      newHeadY = snakeCoord(1,2);
   case 4  % Going down
      % Move the head square downwards. Decrease its y coord. by 1, do not change its x coord.
      newHeadX = snakeCoord(1,1);
      newHeadY = snakeCoord(1,2) - 1;
end


% Update the positions of the squares other than the head square. Each square
% will take the position of the one ine front of it.
snakeCoord(2:end,:) = snakeCoord(1:end-1,:);   % (2:end,:) means all the rows from the
                                               % 2nd to the last, and all the columns,
                                               % i.e. both x and y coordinates of the
                                               % squares other than the head square.
                                               % By equating these to (1:end-1,:),
                                               % we equate the coordinates of the squares,
                                               % other then the head square, to those
                                               % in front of them. Very simple motion. 


% Update snake's head with the previously calculated new head position.
snakeCoord(1,1) = newHeadX;
snakeCoord(1,2) = newHeadY;


% To end the game, detect if the snake hits any of the walls.
% Check if the new x or y position of snake's head went beyond the walls or not.
% || is MATLAB's logical OR operator.
if snakeCoord(1,1) > width-1 || snakeCoord(1,1) < 0 || snakeCoord(1,2) > height-1 || snakeCoord(1,2) < 0
   isGameOver = 1;    % This will be used to terminate the game loop.
   return             % Immediately terminate this function if the game is over.
end

% **************
% CHANGES END
% **************

% Move the snake on the screen if the game did not end
for i = 1:len
   set(snake(i), 'Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1]);
end

end  % of function moveSnake




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyPressed(~, event) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called when the user presses a key of the keyboard.
% Right now, it write the message "Spacebar is pressed" on the command
% window, which is pretty useless. Later we will use it to pause/continue
% the game.

global isPaused direction

% **************
% CHANGES START
% **************

switch event.Key
   case "rightarrow"
      if direction == 2 || direction == 4    % If the right arrow is pressed change the motion direction
         direction = 1;                      % as 1 only if the snake is currently moving up or down.
      end
   case "uparrow"
      if direction == 1 || direction == 3    % If the up arrow is pressed change the motion direction
         direction = 2;                      % as 2 only if the snake is currently right or left.
      end
   case "leftarrow"
      if direction == 2 || direction == 4    % Similar
         direction = 3;   
      end
   case "downarrow"
      if direction == 1 || direction == 3    % Similar
         direction = 4;
      end
   case "space"    % Pause/continue the game when the spacebar is pressed.
      if isPaused        % If game is paused, continue.
         isPaused = 0;
         disp("Game continues.")
      else               % If game is not paused, pause it.
         isPaused = 1;
         disp("Game is paused.")
      end
end

% **************
% CHANGES END
% **************

end   % of function keyPressed