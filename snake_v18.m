% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 18th version of our snake game. Please have a look at the   %
% previous versions before this one.                                      %
%                                                                         %
% This version tries to improve the smoothness and reponsiveness of the   %
% game. It changes the way the game is paused inside the game loop.       %
% Instead of pasuing by pauseAmount, it measures the time the moveSnake   %
% function takes, and pauses that much less than pauseAmount. The aim is  %
% to pause independent of how fast or slow the moveSnake function is      %
% executed. This is a common trick used in games that is constantly       %
% controlled by user inputs, such as our game. To me this version is      %
% more responsive and smooth. But maybe I am fooling myself :-) Try it.   %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v18()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is our main function. It is the first function is our code. Its name
% is the same as the name of the file to avoid confusions.

clc
clear
close

global ax width height isPaused pauseAmount wantToQuit isGameOver


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

   % **************
   % CHANGES BEGIN
   % **************

   tic  % Start a timer

   if ~isPaused && ~isGameOver
      moveSnake();   % Move the snake if the game is not paused
   end
   
   pause(pauseAmount - toc);   % Pause a bit to make snake's motion visible.
                               % This sets the game speed.
                               % "toc" ends the timer that measures the time
                               % it takes to execute the moveSnake function.                           
   % **************
   % CHANGES END
   % **************

end  % of the game loop

end  % of the main function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver isPaused direction score ...
       food foodCoord pauseAmount speedUpFactor gameOverText wantToQuit

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
pauseAmount = 0.3;     % Initialize it to a high value for slow initial motion
speedUpFactor = 0.01;  % How much the PauseAmount will decrease when a food is eaten


% Define our snake's length as 5. It will cover 5 squares of our game board.
len = 5;


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
% Create the head of the snake in diferent color than others. '#......'
% used for the face color is a hexadecimal color code.
snake(1) = rectangle('Position', [snakeCoord(1,1) snakeCoord(1,2) 1 1], ...
                     'FaceColor', '#622569', ...
                     'EdgeColor', 'black');

for i = 2:len
   snake(i) = rectangle('Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1], ...
                        'FaceColor', '#b8a9c9', ...
                        'EdgeColor', 'black');
end


% Calculate the location of the food. Make sure that it is not hidden under
% the snake.
calcFoodCoord()


% Generate the food rectangle to see the food on the screen.
food = rectangle('Position', [foodCoord(1) foodCoord(2) 1 1], ...
                 'Curvature', 0.8, ...
                 'FaceColor', '#5b9aa0', ...
                 'EdgeColor', 'black');


% Create a game over text that will be visible on the figure window when
% the game ends.
gameOverText = text(width/2, height-1, 'Game Over. Press spacebar to restart.', ...
                    'FontSize', 15, ...
                    'HorizontalAlignment', 'center', ...
                    'Color', 'red');

gameOverText.Visible = "off";

pause(1)   % Pause 1 second before the game starts

end  % of the function startGame




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcFoodCoord()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord foodCoord

% Calculate the new food position using MATLAB's built-in randi function.

% We also need to make sure that the food is not covered by the snake.
isFoodVisible = 0;    % An initialized flag that will be used below to make
                      % sure that the new food location is not under the snake
                      % or other foods.

while (~isFoodVisible)    % Generate a new food location until it is visible,
                          % i.e. not under the snake
   
   foodCoord = [randi([0 width-1]) randi([0 height-1])];
   
   % Compare the rows of snakeCoord and foodCoord to see whether there is a
   % match or not. This generates a logical array 0's and 1's. ismember is a
   % MATLAB function used for such checks.
   mask = ismember(snakeCoord, foodCoord, "rows");

   % If there is a 1 in this mask, it means that the food is under the
   % snake. If not the food location is OK.
   if ~ismember(mask, 1)   % Food is not under the snake
      isFoodVisible = 1;
   end

end

end  % of function calcFoodCoord




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver direction score ...
       foodCoord food pauseAmount speedUpFactor gameOverText

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
if snakeCoord(1,:) == foodCoord   % If this is corect we need to eat the food, generate
                                  % a new food and make the snake longer by adding one
                                  % more rectangle to the end of the snake object.

   % The current food is eaten. Let's generate a new random food location and
   % move the food to this new position.
   calcFoodCoord()
   set(food, 'Position', [foodCoord(1) foodCoord(2) 1 1]);

   snakeCoord = [snakeCoord; tail];    % We moved the last square of the snake forward above.
                                       % Now we add the previously copied "tail" to the end
                                       % of the snake to make it longer.

   len = len + 1;      % Increase the length of the snake by 1
   score = score + 1;  % Increase the score by 1
   pauseAmount = pauseAmount - speedUpFactor;   % Speed up the game slightly by
                                                % decreasing the pauseAmount
   
   % Add one more rectangle to the end of our snake object. It will be the
   % last, i.e. the len-th entry.
   snake(len) = rectangle('Position', [snakeCoord(end,1) snakeCoord(end,2) 1 1], ...
                          'FaceColor', '#b8a9c9', ...
                          'EdgeColor', 'black');

   fprintf("Food is eaten. pauseAmount is %.2f. Score is %d. \n", pauseAmount, score);
end


% WALL HIT CHECK: To end the game, detect if the snake hits any of the walls.
% Check if the new x or y position of snake's head went beyond the walls or not.
% MATLAB's logical OR operator is ||.
if snakeCoord(1,1) > width-1 || snakeCoord(1,1) < 0 || snakeCoord(1,2) > height-1 || snakeCoord(1,2) < 0
   isGameOver = 1;
   gameOverText.Visible = "on";   % Make the "Game Over" text visible.
   disp("Game Over. Press spacebar to restart.")
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
function closeWindow(~, ~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Called when the user presses the "close window" button.

global wantToQuit

wantToQuit = 1;   % This will let us go out of the while loop of the main function.

disp("Bye bye...")

delete(gcf)       % Close the figure window.

end
