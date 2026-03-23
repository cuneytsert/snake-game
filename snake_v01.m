% Middle East Technical University
% ME 310 Numerical Methods
% Author: Dr. Cuneyt Sert

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% This is the 1st version of the classical snake game written as a fun    %
% MATLAB coding tutorial for the students of my numerical methods course. %
% Obviously, MATLAB is not the best language for game development, but    %
% games are fun, and coding them (even in MATLAB) is also fun. So, why    %
% not?                                                                    %
%                                                                         %
% In this first version we just create a figure window and decorate it a  %
% bit. You can run the code by pressing F5.                               %
%                                                                         %
% No AI assistance is used in writing these codes. Because I just wanted  %
% to do it myself.                                                        %
%                                                                         %
% Have fun. Happy coding :-)                                              %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Our game board will be a standard MATLAB figure window. Below, we create
% it using MATLAB's figure function and change some of its default features.

figure('Name', 'Snake Game', ...        % Give a name to the figure window.
       'MenuBar','none', ...            % Get rid of the menubar, we don't need it.
       'ToolBar','none', ...            % Get rid of the toolbar, we don't need it.
       'NumberTitle','off', ...         % Get rid of the number in the figure name .
       'Position', [200 200 650 600]);  % Position the figure window on your screen
                                        % by setting its lower left corner to (200,200)
                                        % pixels away from the lower left corner of
                                        % your screen, and set its width and height
                                        % to 650 and 600 pixels, respectively.


% TODO: Get rid of all the above arguments and create the figure window by
% simply using figure(). Then add each argument one by one to understand how
% they work.
