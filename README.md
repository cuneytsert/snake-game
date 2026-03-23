# Snake Game
Middle East Technical University  
Department of Mechanical Engineering  
Ankara, Turkey  
ME 310 Numerical Methods  
Dr. Cuneyt Sert  

This is a step-by-step MATLAB implementation of the classical snake game written as a fun coding tutorial for the students of my numerical methods course. Obviously, MATLAB is not the best language for game development, but games are fun, and coding them (even in MATLAB) is also fun. So, why not?

No AI assistance is used in writing these codes. Because I just wanted to do it myself.

Have fun. Happy coding :-)

Please send your bug reports, requests, comments, questions to csert@metu.edu.tr.

# Version History

**v01:** A figure window is created and decorated.

**v02:** An "axes" is added to the figure window so that we can draw things inside it.

**v03:** A snake and a food are created using MATLAB's built-in rectangle function.

**v04:** Changed the way the snake is created. Now it is composed of multiple squares instead of a single rectangle. Also randomize the food position.

**v05:** Create the snake using a for loop.

**v06:** Our snake can now move. But we are not controlling it yet. It just goes out of the game board.

**v07:** A new variable called cnakeCoord is created to store the coordinates of the squares that make up our snake.

**v08:** The snake is not allowed to go out of the right wall. The game ends and "Game over" message is written in the command window when this happens.

**v09:** The code is divided into three functions, the main function, the startGame function and the moveSnake function. Also a flag variable called isGameOver is now used to keep track of the status of the game.

**v10:** "Game Over" message is also written inside the figure window using MATLAB's built-in text function. Also we now detect when the user presses any key on the keyboard to give the player a feedback. Our game is slowly becoming interactive :-) A new function called keyPressed is introduced.

**v11:** Spacebar can now be used to pause/continue the game. Introduced a new variable called isPaused, whic is used in the keyPressed function and inside the main game loop. Our game is getting more interactive :-)

**v12:** This is a version with some major changes. We begin controlling the snake's motion using the arrow keys. For this, a new variable called direction is introduced to detect where our snake is moving towards. It can be 1, 2, 3 or 4, meaning right, up, left and down. Also change the moveSnake function because now its motion is not simply towards right. The game now ends when the snake hits any of the walls, not only the right wall. Our snake can turn, and our game starts to look like the original one.

**v13:** Our snake can now eat the food. A score variable is introduced, which increases by 1 when a food is eaten. The food's position changes randomly to a new position when it gets eaten. Our snake is happier now.

**v14:** Game speed increases automatically as the foods are eaten. This makes the game more challenging and fun. Also the axes numbers are removed and the game duration is shown on the screen when the game ends.

**v15:** We now detect if the snake curls up and hits itself, and end the game when this happens. Snake's head color is different now to differentiate it from the rest of it. And the food is now a slightly rounded square.

**v16:** Spacebar can be used to restart the game when it ends. This makes it easier to play several games one after the other. Introduced a new flag variable called wantToQuit, which becomes TRUE if the player wants to close the figure window, and this is how the game loop terminates. A new function called closeWindow is added which is called when the user clicks the close button at the top right corner of the game window.

**v17:** A bug is corrected. When a new food position is calculated, we now make sure that it is not under one of the squares occupied by the snake. For this, we created a new function called calcFoodCoord.

**v18:** This version tries to improve the smoothness and reponsiveness of the game. It changes the way the game is paused inside the game loop. Instead of pasuing by pauseAmount, it measures the time the moveSnake function takes, and pauses that much less than pauseAmount.

**v19:** Game speed is increased not linearly but using on a tanh function so that it starts from a minimum and asymptotically reaches a maximum, which are dictated by two new variables pauseAmountMin and pauseAmountMax.

**v20:** Add a fun visual effect when the game ends. When the snake hits a wall or itself, change its color gradually from head to tail. Do this inside a new function called deadAnimation. Introduce a new variable called colors is to store the colors of snake's  head, snake's body, food and dead snake.

**v21:** Multiple foods are shown at once so that the snake can reach and eat them easier. The variable "food" is now an array of size nFood. When the i-th food is eaten, its new coordinate is calculated while the others stay at their places. calcFoodCoord() function now takes in an integer argument showing for which food it is being called.

**v22:** This is a clean up version with several small improvements. See the code for the complete list.

**v23:** A new game mode is introduced where the aim is to eat all the foods as fast as possible. When a food is eaten it is not re-generated, but made invisible. The "food check" of the moveSnake function is taken to a new function called foodCheck. Instead of score, game time is now shown in the figure title. Give this new play mode a try, you may enjoy it :-)

# Known Bugs
If you hit two arrrow keys one after the other too fast to make a U turn,
the snake can make an immediate U turn and go directly backwards. This
is confusing. After version 15, this ends the game due to the snake biting
itself. Needs be corrected.

When a new food is generated at a random location, it can happen to be right
under the snake. This makes the food invisible until the snake moves and
uncovers it. v17 corrects this.

This seems to be a bug of MATLAB Online, but sometimes the game window does
not initialize properly if you are inactive in MATLAB Online for some time.
The window shows nothing. Reload MATLAB Online if this happens. And sometimes
the window does not get closed properly. If this happens, try "Ctrl-C" and
"close force all" commands on the command window a few times. v22 seems to
correct the latter problem partially, but not tested extensively.

This also seems to be a bug of MATLAB Online, but if you resize the game
window, it becomes unresponsive to keyboard inputs. You need to click inside
the game board to make it responsive again.


# Missing Features, Enhancement Ideas
Have multiple foods and try to it them as fast as possible. (Implemented in v23)
Move the food to a new location if it doesn't get eaten within a certain
time period like 5 sec.

Multiple foods (possibly with different sizes, colors, score points) can
be shown at once (partially implemented in v21).

Allow to go out through a wall and re-enter from another instead of dying.

Play sounds when a food is eaten or when the snake hits a wall.

Show a settings window to change board dimensions, keyboard controls,
colors, speed settings, activating/deactivating various features, etc.


