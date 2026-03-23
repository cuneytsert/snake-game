% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 11th version of our snake game. Please have a look at the   %
% previous versions before this one.                                      %
%                                                                         %
% In this version we pause/continue the game when the spacebar is         %
% pressed. We introduced a new variable called isPaused and use it in the %
% keyPressed function and inside the main game loop. Search in this file  %
% for the word keyPressed to see where it is being used. Our game is      %
% getting more interactive :-)                                            %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v11()
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


% This is the main game loop, where the snake moves towards right.
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

   pause(0.3);   % Pause a bit to make snake's motion visible
end

end  % of the main function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver isPaused

clc    % Clear the command window

disp("Welcome to the snake game.")
disp("Pause/continue with the spacebar.")

% Initialize the flags
isGameOver = 0;  % Game is not over initially
isPaused = 0;    % Game is not paused initially

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

pause(2);  % Pause 2 seconds at the beginning of the game.

end  % of the function startGame




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveSnake()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width snakeCoord snake len isGameOver

% Calculate the new positions of the snake's coordinates.
for i = 1:len
   snakeCoord(i,1) = snakeCoord(i,1) + 1;   % Increase x coordinates by 1 to move
                                            % the snake towards right.
                                            % Do not change the y coordinates.
end


% To end the game, detect if the snake hits the right wall or not.
% Check if the new x position of snake's head went beyond the right wall or not.
if snakeCoord(1,1) > width-1
   isGameOver = 1;    % This will be used to terminate the game loop.
   return             % Immediately terminate this function if the game is over.
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

% We are now using the second input argument called "event". We will use it
% to detect which key is pressed.

global isPaused

% **************
% CHANGES START
% **************

if event.Key == "space"    % Pause/continue the game when the spacebar is pressed.
                           % We do this by updating the isPaused flag.
   if isPaused        % If isPaused is TRUE, i.e. equal to 1, the game is paused. The player wants to continue
      isPaused = 0;
      disp("Game continues.")
   else               % If game is not paused, the palyer wants to pause it
      isPaused = 1;
      disp("Game is paused.")
   end
end

% **************
% CHANGES END
% **************

end   % of function keyPressed