% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This version introduces a new game mode where the aim is to eat all the %
% foods as fast as possible. When a food is eaten it is not re-generated, %
% but made invisible. The "food check" of the moveSnake function is taken %
% to a new function called foodCheck. Instead of score, game time is now  %
% shown in the figure title. Give this new play mode a try, you may enjoy %
% it :-)                                                                  %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v23()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is our main function. It is the first function is our code. Its name
% is the same as the name of the file to avoid confusions.

clc
close
clear

global width height nFood colors pauseAmountMin pauseAmountMax pauseAmount ...
       ax wantToQuit gameState startTime


% ========================
% Set the game parameters
% ========================
width   = 22;     % Game board width (number of squares)
height  = 22;     % Game board height
nFood   = 10;     % Number of foods on the game board

colorTheme = "dark";  % Figure color theme. Can be 'light' or 'dark'

if colorTheme == "dark"
   colors = ["#84B179";    % Snake's head color (in hexadecimal)
             "#F8F3E1";    % Snake's body color
             "#FF4400"];   % Food color
else
   colors = ["#234C6A";
             "#6594B1";
             "#ED775A"];
end

pauseAmountMax = 0.2;   % About the slowest game speed at the start
pauseAmountMin = 0.1;   % About the fastest game speed that will be reached eventually

gameState = "none";       % Can be "continues", "paused", "over", "finished".
wantToQuit = 0;           % Flag to check if the player wants to quit or not.


% ======================================================
% Create the figure window and create an axis inside it
% ======================================================
% Our game board is a standard MATLAB figure window.
figure('Name', 'Snake Game', ...             % Give a name to the figure window
       'MenuBar','none', ...                 % Get rid of the menubar, we don't need it
       'ToolBar','none', ...                 % Get rid of the toolbar, we don't need it
       'NumberTitle','off', ...              % Get rid of the number in the figure name
       'KeyPressFcn', @keyPressed, ...       % Which function to call when a key of the keyboard is pressed
       'CloseRequestFcn', @closeWindow, ...  % Which function to call when we press the close button of the figure window
       'Theme', colorTheme, ...              % Set the color theme
       'Position', [200 200 650 600]);       % Position the figure window on your screen
                                             % and set its width and height

% Snake, foods, etc. will be drawn inside the following axis object called ax.
ax = axes();             % Create an axis inside the figure window
grid on;                 % Show grid lines.
axis equal;              % Set the aspect ratio of the x and y axes equal to 1 so that
                         % if the player resizes the figure window, everything will look
                         % nicely scaled.
ax.Box = 'on';           % Put a nice border around the game board to make it look nicer.
                         % Aesthetics is important :-)
ax.XLim = [0 width];     % Set the horizontal axis limits.
ax.YLim = [0 height];    % Similar for the vertical axis.
ax.XTick = 0:1:width;    % Horizontal grid lines will be shown from 0 to width with increments of 1.
                         % This will let us see all the squares of the game board.
ax.YTick = 0:1:height;   % Similar for the vertical grid lines.
ax.XTickLabel = [];      % Do not show the numbers on the horizontal axis.
ax.YTickLabel = [];      % Similar for the vertical axis.
ax.TickDir = 'none';     % Do not show the little tick lines.


% ================================
% Show the welcome text and wait
% ================================
showWelcomeText();   % Show the welcome text with game controls

while gameState == "none"    % Welcome text loop. Will exit when the player
                             % presses the spacebar or quits the game
   if wantToQuit == 1   % The player may want to quit at this point
      disp("Bye bye...")
      delete(gcf)
      return
   end
   pause(0.01);    % Just to be responsive to the player input
end


initializeNewGame();   % Call the initializeNewGame function to create the
                       % initial snake and foods


% ========================================================================
% This is the main game loop. It is an infinite loop. You can exit it by
% closing the figure window which makes the wantToQuit variable TRUE.
% ========================================================================
while(1)
   tic  % Start a timer. Used for the game speed calculation.

   if wantToQuit == 1
      break
   end

   if gameState ~= "paused" && gameState ~= "over" && gameState ~= "finished"
      moveSnake();   % Move the snake if the game is not paused over or finished

      % **************
      % CHANGES START
      % **************
      if gameState ~= "over" && gameState ~= "finished"
         title(['Time = ' num2str(toc(startTime), '%.0f') ' sec']);
      end
   
      % **************
      % CHANGES END
      % **************
   end

   pause(pauseAmount - toc);   % Pause a bit to make snake's motion visible.
                               % This sets the game speed.
                               % "toc" ends the timer that measures the time
                               % it takes to execute the moveSnake function. 
end  % of the game loop

disp("Bye bye...")
delete(gcf)  % Delete the current figure window

end  % of the main function



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function showWelcomeText()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global welcomeText width height

% Use MATLAB's text function to create the welcome message that will be
% shown at the very beginning.
% Use MATLAB's { } notation to define a multi-line text.
txt = {' ', '  Welcome to the snake game  ', ...
       ' ', '  Eat all the foods as fast as possible  ', ...
       ' ', '  Press spacebar to start / pause / continue  ', ...
       ' ', '  Use arrow keys to turn  ', ' '};

welcomeText = text(width/2, height/2, txt, ...
                  'FontSize', 12, ...
                  'HorizontalAlignment', 'center', ...
                  'Color', 'black', ...
                  'BackgroundColor', 'white', ...
                  'EdgeColor', 'black');

end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initializeNewGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len direction score gameState ...
       food foodCoord pauseAmount pauseAmountMax textMessage ...
       colors nFood startTime eatenFoods

clc   % Clear the command window
cla   % Clear the current axes, i.e. delete the current snake, food and text.

disp("Welcome to the snake game.")
disp("Spacebar: Pause/continue/restart.")
disp("Arrow keys: Navigate the snake.")
disp("Do not hit the walls or bite yourself.")


% Perform initializations
gameState  = "continues";      % Set the game state
direction   = 1;               % Snake moves towards right initially 
score       = 0;               % Initial score is zero
pauseAmount = pauseAmountMax;  % Initialize it to a high value for slow initial start
len         = 5;               % Initialize snake's length to 5
eatenFoods  = zeros(nFood,1);  % Make all the foods not eaten


% Set the snake's initial coordinates as a len by 2 matrix. Place it
% horizontally at the middle of the game board.
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


% Generate initial food coordinates
foodCoord = zeros(nFood,2);   % Generate the food coodinates as zero initially

% Calculate the location of the food. Make sure that it is not hidden under
% the snake.
for f = 1:nFood
   calcFoodCoord(f);   % Calculate the position of the f-th food
end

% Generate the food rectangles to see the foods on the screen.
for f = 1:nFood
   food(f) = rectangle('Position', [foodCoord(f,1)+0.1 foodCoord(f,2)+0.1 0.8 0.8], ...
                       'Curvature', 0.8, ...
                       'FaceColor', colors(3), ...
                       'EdgeColor', 'black');
end

% Use MATLAB's text function to create the text message that says "game over"
% or "game finished".
% Use MATLAB's { } notation to define a multi-line text.

textMessage = text(width/2, height/2, ' ', ...
                  'FontSize', 15, ...
                  'HorizontalAlignment', 'center', ...
                  'Color', 'red', ...
                  'BackgroundColor', 'white', ...
                  'EdgeColor', 'red');

textMessage.Visible = "off";   % Make the text message invisible

pause(0.5);   % Pause 0.5 seconds before the game starts

title('Time = 0 sec');


% **************
% CHANGES START
% **************

startTime = tic;   % Start the timer

% **************
% CHANGES END
% **************

end  % of the function initializeNewGame




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function calcFoodCoord(f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord foodCoord

% Calculate the new position of the f-th food using MATLAB's built-in randi
% function.

% We also need to make sure that the food is not covered by the snake or the
% other foods.

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




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len direction score nFood

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


% FOOD CHECK: See whether a food is being eaten right now or not
foodCheck(tail)


% WALL HIT CHECK: To end the game, detect if the snake hits any of the walls.
% Check if the new x or y position of snake's head went beyond the walls or not.
if snakeCoord(1,1) > width-1 || snakeCoord(1,1) < 0 || snakeCoord(1,2) > height-1 || snakeCoord(1,2) < 0
   gameOver()   % End the game by calling this function
   return       % Immediately terminate this function if the game is over.
end


% HIT ITSELF CHECK: To end the game, detect if the snake hits itself.
% Check if the new x or y position of snake's head coincides with any of the other
% rectangles that make up the snake.
head = snakeCoord(1,:);   % Coordinates of snake's head
for i = 2:len   % Loop over other rectangles that make up the snake
   if head == snakeCoord(i,:)
      gameOver()   % End the game by calling this function      
      return       % Immediately terminate this function if the game is over.
   end
end


% Move the snake on the screen if the game did not end
for i = 1:len
   set(snake(i), 'Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1]);
end


% GAME FINISH CHECK
if score == nFood
    gameFinished()
end

end  % of function moveSnake




% **************
% CHANGES START
% **************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function foodCheck(tail) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if the snake is eating a food or not.

global len score snake snakeCoord foodCoord food nFood pauseAmount ...
       pauseAmountMin pauseAmountMax colors eatenFoods 

for f = 1:nFood

   if eatenFoods(f) == 1  % skip this food if it was previously eaten.
       continue
   end

   if snakeCoord(1,:) == foodCoord(f,:)   % If this is corect we need to eat the food, generate
                                          % a new food and make the snake longer by adding one
                                          % more rectangle to the end of the snake object.

      % The f-th food is eaten. Let's hide it.
      set(food(f), 'Visible', 'off');
      eatenFoods(f) = 1;


      snakeCoord = [snakeCoord; tail];    % We moved the last square of the snake forward above.
                                          % Now we add the previously copied "tail" to the end
                                          % of the snake to make it longer.

      len = len + 1;      % Increase the length of the snake by 1
      score = score + 1;  % Increase the score by 1


      % Speed up the game gradually by decreasing the pauseAmount
      pauseAmount = pauseAmountMax - (pauseAmountMax-pauseAmountMin)*tanh(score/15);
   

      % Add one more rectangle to the end of our snake object. It will be the
      % last, i.e. the len-th entry.
      snake(len) = rectangle('Position', [snakeCoord(end,1) snakeCoord(end,2) 1 1], ...
                             'FaceColor', colors(2), ...
                             'EdgeColor', 'black');

      fprintf("Score = %d\n", score);

      break;   % There is no need to check if other foods get eaten if food f is eaten
   end
end

end  % of function foodCheck

% **************
% CHANGES END
% **************




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gameOver() 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called when the game is over.
 
global gameState textMessage

gameState = "over";
txt = {' ', 'Game Over', ' ', '   Press spacebar to restart   ', ' '};
set(textMessage', 'String', txt);
textMessage.Visible = "on";
uistack(textMessage, 'top');
disp("Game Over. Press spacebar to restart.")
animateSnake()   % Play the game over/finished animation

end




% **************
% CHANGES START
% **************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function gameFinished() 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called when the game is finished, i.e. all the foods are
% eaten.
 
global gameState textMessage startTime

gameState = "finished";
txt = {' ', ['Done in ' num2str(toc(startTime), '%.0f') ' sec.'], ...
       ' ', '   Press spacebar to restart   ', ' '};
set(textMessage', 'String', txt);
textMessage.Visible = "on";
uistack(textMessage, 'top');
disp("Done. Press spacebar to restart.")
animateSnake()   % Play the game over/finished animation

end

% **************
% CHANGES END
% **************



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyPressed(~, event) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called when the player presses a key of the keyboard.
% Right now, it write the message "Spacebar is pressed" on the command
% window, which is pretty useless. Later we will use it to pause/continue
% the game.
 
global direction gameState

if gameState == "over" || gameState == "finished"
   if event.Key == "space"
      initializeNewGame()     % Restart the game when the game is over and spacebar is pressed.
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
         if gameState == "none"
             gameState = "continues";
         end
         if gameState == "paused"        % If game is paused, continue
            gameState = "continues";
            disp("Game continues.")
         else               % If game is not paused, pause it
            gameState = "paused";
            disp("Game is paused.")
         end
   end
end

end   % of function keyPressed




% **************
% CHANGES START
% **************

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function animateSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Animate the snake by changing its color repeatedly a few times when the
% game is over or finished.

global snake len colors

% Change snake's color between two colors alternatively a few times
for k = 1:10
   c = mod(k,2)+1;   % c alternates between 1 and 2

   % Paint the snake in color c
   for i=1:len
      set(snake(i), 'FaceColor', colors(c));
   end

   pause(0.08)
end

end   % of function gameOverAnimation

% **************
% CHANGES END
% **************




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function closeWindow(~, ~)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Called when the player presses the "close window" button.

global wantToQuit

wantToQuit = 1;   % This will let us go out of the while loop of the main function.

end
