% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 21st version of our snake game. Please have a look at the   %
% previous versions before this one.                                      %
%                                                                         %
% In this version we have multiple foods at once so that the snake can    %
% reach and eat them easier. The variable "food" is now an array of size  %
% nFood. When the i-th food is eaten, its new coordinate is calculated    %
% while the others stay at their places. calcFoodCoord() function now     %
% takes in an integer argument showing for which food it is being called. %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v21()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is our main function. It is the first function is our code. Its name
% is the same as the name of the file to avoid confusions.

clc
close
clear

global ax width height isPaused pauseAmount wantToQuit isGameOver ...
       pauseAmountMin pauseAmountMax

% Here is our figure window.
figure('Name', 'Snake Game', ...           % Give a name to the figure window.
       'MenuBar','none', ...               % Get rid of the menubar, we don't need it.
       'ToolBar','none', ...               % Get rid of the toolbar, we don't need it.
       'NumberTitle','off', ...            % Get rid of the number in the figure name .
       'Position', [200 200 650 600], ...  % Set the size and position of the window.
       'KeyPressFcn', @keyPressed, ...     % Bind the key press event to our new keyPressed function.
       'CloseRequestFcn', @closeWindow);   % Bind the window close event to our new closeWindow function.


% Let's play the game on a 20x20 board.
width = 20;      % Game board width
height = 20;     % Game board height

pauseAmountMax = 0.3;     % About the slowest game speed at the start
pauseAmountMin = 0.1;     % About the fastest game speed that will be reached eventually.


% And here is our axis.
ax = axes();               % We need an axes object to draw the snake and the food.
grid on;                   % Show grid lines.
axis equal;                % Set the aspect ratio of the x and y axes to 1.
ax.Box = 'on';             % Put a nice border around the game board to make it look nicer.
ax.XLim = [0 width];       % Set the horizontal axis limits.
ax.YLim = [0 height];      % Similar for the vertical axis.
ax.XTick = 0:1:width;      % Horizontal grid lines will be shown from 0 to width with increments of 1.
ax.YTick = 0:1:height;     % Similar for the vertical grid lines.
ax.XTickLabel = [];        % Do not show the numbers on the horizontal axis.
ax.YTickLabel = [];        % Similar for the y axis


pause(2);   % Pause a little bit before the first game starts.

startGame();   % Call the startGame function


% This is the main game loop, where the snake moves.
% It is terminates when wantToQuit becomes TRUE which happens when the user
% closes the figure window.
while(~wantToQuit)

   tic  % Start a timer
   
   if ~isPaused && ~isGameOver
      moveSnake();   % Move the snake if the game is not paused
   end

   pause(pauseAmount - toc);   % Pause a bit to make snake's motion visible.
                               % This sets the game speed.
                               % "toc" ends the timer that measures the time
                               % it takes to execute the moveSnake function. 
end  % of the game loop

end  % of the main function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver isPaused direction score ...
       food foodCoord pauseAmount pauseAmountMax gameOverText wantToQuit ...
       colors nFood

clc    % Clear the command window

disp("Welcome to the snake game.")
disp("Spacebar: Pause/continue/restart.")
disp("Arrow keys: Navigate the snake.")
disp("Do not hit the walls or bite yourself.")


cla   % Clear the current axes, i.e. delete the current snake and food.


% Perform initializations
isGameOver = 0;        % Game is not over initially
isPaused = 0;          % Game is not paused initially
wantToQuit = 0;        % User does not want to quit now
direction = 1;         % Snake moves towards right initially 
score = 0;             % Initial score is zero
pauseAmount = pauseAmountMax;    % Initialize it to a high value for slow initial start

len = 5;      % Snake's length. It will cover this many squares of our game board
nFood = 15;   % Number of foods on the game board

% Define colors in hexadecimal.
colors = ["#234C6A"; "#6594B1"; "#ED775A"; "#E491C9"];   % Colors for snake's head, snake's

% Define the snake's initial coordinates as a len by 2 matrix. Place it
% horizontally in the middle of the game board.
headX = round(width/2);     % An integer for the x position of snake's head
headY = round(height/2);    % An integer for the y position of snake's head
snakeCoord = [headX   headY;
              headX-1 headY;
              headX-2 headY;
              headX-3 headY;
              headX-4 headY];

% Use these coordinates to create our snake's squares
% Create the head of the snake in diferent color than others.
snake(1) = rectangle('Position', [snakeCoord(1,1) snakeCoord(1,2) 1 1], ...
                     'FaceColor', colors(1), ...
                     'EdgeColor', 'black');

for i = 2:len
   snake(i) = rectangle('Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1], ...
                        'FaceColor', colors(2), ...
                        'EdgeColor', 'black');
end



% **************
% CHANGES START
% **************

foodCoord = zeros(nFood,2);   % Generate the food coodinates as zero initially

% Calculate the location of the food. Make sure that it is not hidden under
% the snake.
for f = 1:nFood
   calcFoodCoord(f);   % Calculate the position of the f-th food
end

% Generate the food rectangles to see the foods on the screen.
for f = 1:nFood
   food(f) = rectangle('Position', [foodCoord(f,1) foodCoord(f,2) 1 1], ...
                       'Curvature', 0.8, ...
                       'FaceColor', colors(3), ...
                       'EdgeColor', 'black');
end

% **************
% CHANGES END
% **************


% Create a game over text that will be visible on the figure window when
% the game ends.
gameOverText = text(width/2, height-1, 'Game Over. Press spacebar to restart.', ...
                    'FontSize', 15, ...
                    'HorizontalAlignment', 'center', ...
                    'Color', 'red');

gameOverText.Visible = "off";

pause(0.5);   % Pause 0.5 second before the game starts

end  % of the function startGame




% **************
% CHANGES START
% **************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcFoodCoord(f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord foodCoord

% Calculate the new position of the f-th food using MATLAB's built-in randi
% function.

while (1)    % Generate a new food until it is visible, i.e.
             % not under the snake or another food
   
   % Generate a new food coordinate
   newCoord = [randi([0 width-1]) randi([0 height-1])];

   % Compare the rows of snakeCoord and foodCoord to see whether there is a
   % match or not. This generates a logical array 0's and 1's.
   bothSnakeAndFood = [snakeCoord; foodCoord];
   mask = ismember(bothSnakeAndFood, newCoord, "rows");

   % If the mask is full of zeros, the new food's location is good and it is
   % visible. We can terminate the while loop.
   if sum(mask) == 0   % Food is not covered by the snake or other foods
      break;
   end
end

% Set the f-th food location to the newly created location.
foodCoord(f,:) = newCoord;

end  % of function calcFoodCoord

% **************
% CHANGES END
% **************




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver direction score ...
       foodCoord food nFood pauseAmount pauseAmountMin pauseAmountMax ...
       gameOverText colors

% Make a copy of the postion of snake's last square. We will need it to make
% the snake longer in case a food is eaten.
tail = snakeCoord(end,:);


% Then, determine the new position of snake's head by looking at the motion direction.
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
snakeCoord(2:end,:) = snakeCoord(1:end-1,:);


% Update snake's head with the previously calculated new head position.
snakeCoord(1,1) = newHeadX;
snakeCoord(1,2) = newHeadY;


% FOOD CHECK: Check if snake's new head location corresponds with the food
% location or not.
for f = 1:nFood
   if snakeCoord(1,:) == foodCoord(f,:)   % If this is corect we need to eat the food, generate
                                          % a new food and make the snake longer by adding one
                                          % more rectangle to the end of the snake object.

      % The f-th food is eaten. Let's generate a new random food location and
      % move the food to this new position.
      calcFoodCoord(f)
      set(food(f), 'Position', [foodCoord(f,1) foodCoord(f,2) 1 1]);

      snakeCoord = [snakeCoord; tail];    % We moved the last square of the snake forward above.
                                          % Now we add the previously copied "tail" to the end
                                          % of the snake to make it longer.

      len = len + 1;      % Increase the length of the snake by 1
      score = score + 1;  % Increase the score by 1


      % Speed up the game gradually by decreasing the pauseAmount
      pauseAmount = pauseAmountMax - (pauseAmountMax-pauseAmountMin)*tanh(score/10);
   

      % Add one more rectangle to the end of our snake object. It will be the
      % last, i.e. the len-th entry.
      snake(len) = rectangle('Position', [snakeCoord(end,1) snakeCoord(end,2) 1 1], ...
                             'FaceColor', colors(2), ...
                             'EdgeColor', 'black');

      fprintf("Score = %d\n", score);

      break;   % There is no need to check if other foods get eaten if food f is eaten
   
   end

end


% WALL HIT CHECK: To end the game, detect if the snake hits any of the walls.
% Check if the new x or y position of snake's head went beyond the walls or not.
% MATLAB's logical OR operator is ||.
if snakeCoord(1,1) > width-1 || snakeCoord(1,1) < 0 || snakeCoord(1,2) > height-1 || snakeCoord(1,2) < 0
   isGameOver = 1;
   gameOverText.Visible = "on";   % Make the "Game Over" text visible.
   disp("Game Over. Press spacebar to restart.")
   deadAnimation()
   return  % Immediately terminate this function if the game is over.
end


% HIT ITSELF CHECK: To end the game, detect if the snake hits itself.
% Check if the new x or y position of snake's head coincides with any of the other
% rectangles that make up the snake.
head = snakeCoord(1,:);   % Coordinates of snake's head
for i = 2:len   % Loop over other rectangles that make up the snake
   if head == snakeCoord(i,:)
      isGameOver = 1;
      gameOverText.Visible = "on";   % Make the "Game Over" text visible.
      disp("Game Over. Press spacebar to restart.")
      
      deadAnimation()
      return  % Immediately terminate this function if the game is over.
   end
end


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
 
global isPaused direction isGameOver

if isGameOver
   if event.Key == "space"
      startGame()          % Restart the game when the game is over and spacebar is pressed.
   end
else
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
         if isPaused        % If game is paused, continue
            isPaused = 0;
            disp("Game continues.")
         else               % If game is not paused, pause it
            isPaused = 1;
            disp("Game is paused.")
         end
   end
end

end   % of function keyPressed




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function deadAnimation()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Called when the snake dies. It paints the snake from head to tail with a
% different color

global snake len colors

for i=1:len
    set(snake(i), 'FaceColor', colors(4));
    pause((0.06*i+0.01-0.07*len)/(1-len));    % Pause based on i to make
end                                           % the animation a bit cooler.

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function closeWindow(~, ~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Called when the user presses the "close window" button.

global wantToQuit

wantToQuit = 1;   % This will let us go out of the while loop of the main function.

disp("Bye bye...")

delete(gcf)       % Close the figure window.

end
