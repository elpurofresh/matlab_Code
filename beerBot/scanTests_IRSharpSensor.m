
%% Clear workspace
clear;clc;

%% Read data from file
filename1 = 'C:\andres\Data\Personal\beerBot\scanTests\scanTestPolar_0.txt'; % File that has the data;
[dist, angle] = textread(filename1, '%f%f');                                % Store values into variables
lineNum = length(dist);                                                     % Number of data in text file

%% Declare variables
normDist = zeros(lineNum, 1);
normAngle = zeros(lineNum, 1);
x_val = zeros(lineNum, 1);
y_val = zeros(lineNum, 1);
x_val_Pos = zeros(lineNum, 1);
y_val_Pos = zeros(lineNum, 1);

%% Transform Polar to Cartesian coordinates

for i = 1:lineNum
    normDist(i, 1)  = (2914/(dist(i)+5))-1;                                       % Linearization of distance data
    normAngle(i, 1) = degtorad(angle(i));                                 
    
    x_val(i, 1) = normDist(i, 1) * cos(normAngle(i, 1));
    y_val(i, 1) = normDist(i, 1) * sin(normAngle(i, 1));
    
    if y_val(i, 1) > 0 
        y_val_Pos(i, 1) = y_val(i, 1);
    end
end

%% Plot 2D Scan

scatter(x_val, y_val);
xlim([-100.0, 100.0]);
ylim([-50.0, 100.0]);





