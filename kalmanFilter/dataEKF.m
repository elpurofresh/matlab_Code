%-------------------------------------------------------------------------
% FILE: dataEKF.m
% DESC: Measured data (simulated) of robot position in x-y frame.  Also 
%       gives a measure of the angle theta between the horizontal and the 
%       robot's velocity vector.
%-------------------------------------------------------------------------

clear all; clc;

N = 10;

%---------------------SIMULATE NOISY MEASUREMENT--------------------------
z = zeros(3,N);
z(1,:) = [0, 2, 4, 10, 11, 10, 10, 10, 9, 8];
z(2,:) = [0, 1, 3, 1, 5, 9, 12, 14, 16, 18];
z(3,:) = [0, 0.25, 0.65, 1.0, 1.05, 1.4, 1.8, 2.0, 2.3, 2.5];
deltaT = 1;     % time between samples
%-------------------------------------------------------------------------