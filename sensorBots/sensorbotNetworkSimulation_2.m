%sensorbotNetworkSimulation_1.m 
%by Andres Mora
%requires Library "matlab_bgl" by David F. Gleich

% Clean workspace and command prompt's window
clear; clc;

% Add library's path. Here you add the path where you chose to download,
% unzip, and save the library.
addpath('C:/andres/Code/matlab/libraries/matlab_bgl');

% Constant time drift (in nanosecs) for a single hop between any two nodes.
timeDrift = 176.6e-9;

% The network's topology can be controlled by changing the values of the
% matrix "a" below. It is made such that the intersection between a row and
% column determine if there is a communication link between the nodes they
% represent. For example, node 0 (master node) and node 1 (child 1) are
% connected and this is done by inputing a value of "1" in the Node0-Node1 
% and % Node1-Node0 intersection of the matrix. Please be careful to write
% it in this way otherwise the program will not work as expected.

% In this matrix Node 0 corresponds to the Master Node.
% Remember that Matlab's convention on counting starts with 1 instead of 0.
%Node 0 1 2 3 4 5 6 
a =  [0 1 1 0 0 0 0;  %0
      1 0 0 1 0 0 0;  %1
      1 0 0 0 0 0 1;  %2
      0 1 0 0 1 1 0;  %3
      0 0 0 1 0 0 0;  %4
      0 0 0 1 0 0 0;  %5
      0 0 1 0 0 0 0]; %6

% In order to use the "matlab_bgl", we need to transform
% our "a" matrix into a sparse matrix 
[i,j,s] = find(a);
[m,n] = size(a);
A = sparse(i,j,s,m,n);

% bfs(sparseMatrix, referenceNode) returns the "distance"  d from the reference
% node to every node, the computational time to get to every node "dt" and
% the predecessor "pred" of every node.
% Making the parameter "referenceNode" = 1, we get the plot describing the 
% topology having the parent at the top of the generated tree.
referenceNode = 2;
[d dt pred] = bfs(A, referenceNode);

% It is nice to see the topology of the network based on the reference
% node. The reference node is placed at the top of the topology (tree).
%treeplot(pred);
treeplot_Andres(pred, referenceNode);

% These variable hold the worst case maximum number of hops and the worst 
% case time drift from the reference node's point of view.
maxNumHops = max(d);
worstCase = maxNumHops * timeDrift;

%Some manipulation to print it in the plot
str1 = strcat('Worst Case Number Hops: ', num2str(maxNumHops, 1));
str2 = strcat('Worst Case Time Drift(sec): ', num2str(worstCase, 4));
textString(1) = {str1};
textString(2) = {str2};
%text(4.5, 9.5, textString);
set(text(4.5, 9, textString, 'VerticalAlignment','bottom', 'HorizontalAlignment','left'), 'BackgroundColor', [1 1 0.6]);

%Title
titleString = strcat('Reference Node -->', num2str(referenceNode, 1));
title(titleString);

%Add grid
grid on;

%Axes labels
%ylabel(['height = ' num2str(max(d))]);
