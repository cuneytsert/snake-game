% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 6th version of our snake game. Please have a look at the    %
% previous versions before this one.                                      %
%                                                                         %
% Our snake can move in this version. Our game now has a game loop, which %
% is a while loop. But we are not controlling our snake yet. It just goes %
% out of the game board.                                                  %
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

% Let's create our snake inside a for loop. The loop's counter "i" is used to
% change the x coordinate of each rectangle of the snake. The first square is
% at x=7, the 2nd one is at x=6, etc. The tail is at x=3. Our snake is horizontal,
% therefore, we do not change the y coordinates of the rectangles.
for i = 1:len
   snake(i) = rectangle('Position', [8-i 10 1 1], ...
                        'FaceColor', 'black', ...
                        'EdgeColor', 'red');
end

% To randomize the food's location, we use MATLAB's built-in randi function.
foodX = randi([0 width-1]);    % A random integer number between 0 and width-1.
foodY = randi([0 height-1]);   % A random integer number between 0 and height-1.
food  = rectangle('Position', [foodX foodY 1 1], ...
                  'FaceColor', 'blue', ...
                  'EdgeColor', 'blue');



% **************
% CHANGES START
% **************

pause(2);  % Pause 2 seconds before entering the game loop.

% Let's move our snake towards right inside an infinite while loop, i.e. the
% game loop. To move our snake, we need to update the "Position" variable of
% each rectangle that forms it. We will increase the x coordinates of each
% rectangle by 1 inside the loop. For this we will use MATLAB's built-in
% set function.
while(1)   % Game loop
   for i = 1:len
      % To move the snake towards right, we need to add 1 to the x coordinates
      % of all the rectangles that form it. Below, snake(i) is the i-th rectangle
      % of the snake. Each rectangle has many properties. We want to change the
      % first entry of the Position property, which is the x coordinate of the
      % lower left corner of the rectangle. For this, we use the "dot notation".
      newX = snake(i).Position(1) + 1;    % Increase x coordinates by 1
      newY = snake(i).Position(2);        % Do not change the y coordinates

      % Now update snake(i)'s Position property using MATLAB's set function.
      set(snake(i), 'Position', [newX newY 1 1]);
   end

   pause(0.5);   % Pause a half second to see the motion of the snake. Otherwise
                 % it will move too fast, and we cannot see anyhting.
                 
                 % WARNING: Do not set the pause amount to zero because
                 % this may result in an unresponsive figure window. If
                 % that happens, you can kill the game using Ctrl-C in the
                 % command window.
end


% TODO: Try to move the snake towards left.
%       Try to position the snake vertically, and move it up or down.
%       Change the pause amount inside the while loop to get a faster or slower
%       motion of the snake, but do not set it to zero.