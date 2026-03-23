% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 15th version of our snake game. Please have a look at the   %
% previous versions before this one.                                      %
%                                                                         %
% In this version we detect if the snake curls up and bites itself, and   %
% end the game when it happens. Snake's head color is different now to    %
% differentiate it from the rest of the snake. And the food is now a      %
% slightly rounded square.                                                %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v15()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is our main function. It is the first function is our code. Its name
% is the same as the name of the file to avoid confusions.

global ax width height isGameOver isPaused pauseAmount


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
ax.XTickLabel = [];        % Do not show the numbers on the horizontal axis.
ax.YTickLabel = [];        % Similar for the y axis


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
   
   pause(pauseAmount);   % Pause a bit to make snake's motion visible
                         % This pauseAmount decreases as the snake gets
                         % longer by eating foods. This sets the game speed.
end  % of the game loop

end  % of the main function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver isPaused direction score ...
       food foodCoord pauseAmount speedUpFactor

clc    % Clear the command window

disp("Welcome to the snake game.")
disp("Pause/continue with the spacebar.")
disp("Use arrow keys to turn the snake.")
disp("Do not hit the walls or bite yourself.")


% Perform initializations
isGameOver = 0;        % Game is not over initially
isPaused = 0;          % Game is not paused initially
direction = 1;         % Snake moves towards right initially 
score = 0;             % Initial score is zero.
pauseAmount = 0.3;     % Initialize it to high value for slow initial motion.
speedUpFactor = 0.01;  % How much the PauseAmount will decrease when a food is eaten.

% Define our snake's length as 5. It will cover 5 squares of our game board.
len = 5;


% Define the snake's initial coordinates as a len by 2 matrix.
snakeCoord = [5 10;   
              4 10;
              3 10;
              2 10;
              1 10];

% **************
% CHANGES START
% **************

% Use these coordinates to create our snake's squares
% Create the head of the snake in diferent color than others. '#......'
% used for the face color is a hexadecimal color code.
snake(1) = rectangle('Position', [snakeCoord(1,1) snakeCoord(1,2) 1 1], ...
                     'FaceColor', '#c94c4c', ...
                     'EdgeColor', 'black');

for i = 2:len
   snake(i) = rectangle('Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1], ...
                        'FaceColor', '#eea29a', ...
                        'EdgeColor', 'black');
end

% **************
% CHANGES END
% **************

% To randomize the food's location, we use MATLAB's built-in randi function.
foodCoord = [randi([0 width-1]) randi([0 height-1])];
food = rectangle('Position', [foodCoord(1) foodCoord(2) 1 1], ...
                 'Curvature', 0.8, ...
                 'FaceColor', '#b1cbbb', ...
                 'EdgeColor', 'black');

pause(2)   % Pause 2 seconds before the game starts

end  % of the function startGame




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver direction score ...
       foodCoord food pauseAmount speedUpFactor


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
   foodCoord = [randi([1 width-2]) randi([1 height-2])];
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
                          'FaceColor', '#eea29a', ...
                          'EdgeColor', 'black');

   fprintf("Food is eaten. Score is %d. \n", score);
end


% WALL HIT CHECK: To end the game, detect if the snake hits any of the walls.
% Check if the new x or y position of snake's head went beyond the walls or not.
% MATLAB's logical OR operator is ||.
if snakeCoord(1,1) > width-1 || snakeCoord(1,1) < 0 || snakeCoord(1,2) > height-1 || snakeCoord(1,2) < 0
   isGameOver = 1;    % This will be used to terminate the game loop.
   return             % Immediately terminate this function if the game is over.
end


% **************
% CHANGES START
% **************

% HIT ITSELF CHECK: To end the game, detect if the snake hits itself.
% Check if the new x or y position of snake's head coincides with any of the other
% rectangles that make up the snake.
head = snakeCoord(1,:);   % Coordinates of snake's head
for i = 2:len   % Loop over other rectangles that make up the snake
   if head == snakeCoord(i,:)
      isGameOver = 1;    % This will be used to terminate the game loop.
      return             % Immediately terminate this function if the game is over.
   end
end

% **************
% CHANGES END
% **************



% Move the snake on the screeif the game did not end
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

end   % of function keyPressed