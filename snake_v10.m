% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 10th version of our snake game. Please have a look at the   %
% previous versions before this one.                                      %
%                                                                         %
% In this version we also write the "Game Over" message inside the figure %
% window to learn how to use MATLAB's built-in text function. We also     %
% detect when the user presses a key on the keyboard. Our game is slowly  %
% becoming interactive :-) And we added a new function called keyPressed  %
% to perform something when a key is pressed.                             %
%                                                                         %
% No AI assistance is used in writing this code. Because I just wanted to %
% do it myself.                                                           %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function snake_v10()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is our main function. It is the first function is our code. Its name
% is the same as the name of the file to avoid confusions.

global ax width height isGameOver


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
   moveSnake();   % Call the moveSnake function

   % Terminate the game loop if the game ended
   if isGameOver

      % **************
      % CHANGES START
      % **************

      % Show the "Game Over" text close to the top of the axes. For this we
      % use MATLAB's text function. First two arguments are the position of
      % the text inside the axes.
      gameOverText = text(width/2, height-1, 'Game Over', 'FontSize', 15, ...
                          'HorizontalAlignment', 'center', 'Color', 'red');

      % **************
      % CHANGES END
      % **************
      
      break    % Terminate the game loop
   end

   pause(0.3);   % Pause a bit to make snake's motion visible
end

end  % of the main function




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function startGame()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global width height snakeCoord snake len isGameOver

clc    % Clear the command window

disp("Welcome to the snake game.")
disp("Press any key and I'll detect it.")

% Set the new variable isGameOver to false, i.e. 0.
isGameOver = 0;

% Define our snake's length as 5. It will cover 5 squares of our game board.
len = 5;


% Define the snake's initial coordinates as a len by 2 matrix.
snakeCoord = [6 10;   
              5 10;
              4 10;
              3 10;
              2 10];

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
                                            % tsnake towards right.
                                            % Do not change the y coordinates.
end


% Detect if the snake hits the right wall to end the game.
% Check if the new x position of snake's head went beyond the right wall or not.
if snakeCoord(1,1) > width-1
   isGameOver = 1;    % This will be used to terminate the game loop.
   return             % Immediately terminate this function when the game is over.
end

% Move the snake on the screen if the game did not end
for i = 1:len
   set(snake(i), 'Position', [snakeCoord(i,1) snakeCoord(i,2) 1 1]);
end

end  % of function moveSnake




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyPressed(~, ~) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is called when the user presses a key of the keyboard.
% Right now, it displays the message "You pressed a key" on the command
% window, when any key is pressed. Later we will use it to pause/continue/
% restart the game.

% This function receives two input arguments. Both of them are shown as ~,
% which is just a placeholder. It means that we will not make use of these
% arguments.

disp("You pressed a key.")

end   % of function keyPressed