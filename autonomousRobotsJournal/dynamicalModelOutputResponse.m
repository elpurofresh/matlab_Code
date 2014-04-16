%%% Based on
%%% http://www.weizmann.ac.il/matlab/toolbox/ident/ch3tut3.html


%% Clear workspace
%clear;clc;

%% Read data from file
filename1 = 'C:\andres\Dropbox\ASU\Projects\iver\Raw Data\IVER Data\20120208_143853_pleasant_2_7_12_lawn1_short_300_500_IVER2-95.log'; %'Lawn_horiz_1v2.log';
[lat1, lon1, gpsSpd1, gpsTrueHead1, powerWatts1] = ...
    textread(filename1, '%n%n%*s%*s%*n%n%n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*[^\n]', 'delimiter', ';', 'headerlines', 1);
    %textread(filename1,
    %'%*n%*n%*s%*s%*n%n%n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*[^\n]', 'delimiter', ';', 'headerlines', 1);

filename2 = 'C:\andres\Dropbox\ASU\Projects\iver\Raw Data\IVER Data\20120208_155753_pleasant_2_7_12_lawn_300_1000_forward_IVER2-95.log';
[lat2, lon2, gpsSpd2, gpsTrueHead2, powerWatts2] = ...
    textread(filename2, '%n%n%*s%*s%*n%n%n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*[^\n]', 'delimiter', ';', 'headerlines', 1);
    %textread(filename2, '%*n%*n%*s%*s%*n%n%n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*n%*s%*n%*n%*n%*n%*n%*n%*[^\n]', 'delimiter', ';', 'headerlines', 1);

%% Transform lat,lon angles to y, x meter coordinates with first lat and
%  lon values as references points.
% Plots the trajectories of the experiments ran at Lake Pleasant earlier in
% 2012.

lat1_ref = lat1(1);
lon1_ref = lon1(1);

lat2_ref = lat2(1);
lon2_ref = lon2(1);

earthRadius = 6371*1000; %6371km in meters
xCoord_1 = zeros(length(lat1), 1);
yCoord_1 = zeros(length(lat1), 1);

xCoord_2 = zeros(length(lat2), 1);
yCoord_2 = zeros(length(lat2), 1);


for i= 1:length(lat1)
    xCoord_1(i) = earthRadius * sin(lon1(i)) * cos(lat1(i));
    xCoord_1(i) = xCoord_1(i) - (-3.5672e+006);          % This value is the min(xCoord_1), it makes the graph positive on the x-axis
    yCoord_1(i) = earthRadius * sin(lon1(i)) * sin(lat1(i));
end

posGps_1 = [xCoord_1(1:end), yCoord_1(1:end)];

figure(1); plot(xCoord_1, yCoord_1);

for i= 2:length(lat2)
    xCoord_2(i) = earthRadius * sin(lon2(i) - lon2_ref) * cos(lat2(i) - lat2_ref);
    yCoord_2(i) = earthRadius * sin(lon2(i) - lon2_ref) * sin(lat2(i) - lat2_ref);
end

figure(2); plot(xCoord_2, yCoord_2);

    
%% Create input and output matrices
input1 = [gpsSpd1, gpsTrueHead1];
output1 = powerWatts1;

input2 = [gpsSpd2, gpsTrueHead2];
output2 = powerWatts2;

t_int = 1; %0.5; %time interval is 2Hz = 0.5secs


%% Create data object
dataObject = iddata(output1, input1, t_int); 
dataObject2 = iddata(output2, input2, t_int); 

%% Naming inputs & outputs
dataObject.InputName  = {'GpsSpd1', 'Orient1'};
dataObject.OutputName = 'Power1';

dataObject2.InputName  = {'GpsSpd2', 'Orient2'};
dataObject2.OutputName = 'Power2';

%% Select First half of data for evaluation
% building a model
%numSamples = 2500; 
numSamples = length(input1)/2;
%numSamples = length(input1);

%numSamples = length(input);
%ze = dataObject(numSamples:end);
ze = dataObject(1:numSamples);

%% Plot the interval sample from 1 to numSamples
%plot(ze(1:numSamples)); 

%% Remove the constant levels and make the data zero-mean.
ze = detrend(ze);

%% Let us first estimate the impulse response of the system by correlation analysis 
% to get some idea of time constants and the like.
%impulse(ze,'sd',3);

%% Estimate a discrete-time state-space model using n4sid, which applies the
%  subspace method. (orders 2 to 8)
%opt = {'Focus', 'simulation'};
init_sys = n4sid(ze,2:8,'Focus', 'simulation'); %simulation stability

%% Build a state-space model where the order is automatically determined,
%  using a prediction error method.
%model = pem(ze);
model = pem(ze, init_sys);

%% Simulate it and compare the model output with measured output. We then
%  select a portion of the original data that was not used to build the model, 
%  e.g., from sample 800 to 900.
%zv = dataObject(1:numSamples);
%zv = dataObject(numSamples);
zv = dataObject(numSamples:(end-1200));
zvDetrend = detrend(zv);
compare(zvDetrend,model);

hold;

%% Using ARX modeling
%model2 = arx(ze,'na',1,'nb',[4 2],'nk',[1 2], 'Focus', 'simulation');
model2 = arx(ze, model, 'Focus', 'simulation');
compare(zvDetrend, model2);

%% Using ARXMAX modeling
opt = armaxOptions;
opt.Focus = 'simulation';
opt.SearchMethod = 'lm';
opt.SearchOption.MaxIter = 10;
opt.Display = 'on';
model3 = arxmax(ze, [2 2 2 1], opt);
model4 = arxmax(ze, model3);
compare(zvDetrend, model3, model4);

%% To retrieve the properties/matrices/vectors of this model we could, e.g., find the A
% matrix of the state space representation by
%ModelProps = model.a;
A = model.a;
B = model.b;
C = model.c;
D = model.d;
K = model.k;
%x_ini = model.x;
x_ini = [0; 0];

numInputs2 = length(input1); %/2;

t = 0:1:numInputs2-1; % time vector

u = input1; % Input vector
%u = input1; %or this one

%output1 = lsim(A, B, C, D, u, t);
lsim(A, B, C, D, u, t, x_ini)

%plot(t,output1,'b'), grid,xlabel('Time (s)'),
%ylabel('Power'),title('Output Signals for the Systems');